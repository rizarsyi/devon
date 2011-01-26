#Gustavo Rezende <nsigustavo@gmail.com>
#Baseado em:
## Copyright (C) 2006 Aaron Griffin
# Copyright (C) 2008 Rodrigo Pinheiro Marques de Araujo
#
# This program is free software; you can redistribute it and/or modify it under
# the terms of the GNU General Public License as published by the Free Software
# Foundation; either version 2 of the License, or (at your option) any later
# version.
#
# This program is distributed in the hope that it will be useful, but WITHOUT
# ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
# FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more
# details.
#
# You should have received a copy of the GNU General Public License along with
# this program; if not, write to the Free Software Foundation, Inc., 51
# Franklin Street, Fifth Floor, Boston, MA 02110-1301, USA.

import sys, tokenize, cStringIO, types
from token import NAME, DEDENT, NEWLINE, STRING
from keyword import kwlist

debugstmts=[]
def dbg(s): debugstmts.append(s)
def showdbg():
    for d in debugstmts: print "DBG: %s " % d

def complete(contentfile, match, line):
    cmpl = Completer()
    cmpl.evalsource(contentfile, line)
    all = cmpl.get_completions(match,'') + kw_complete(match)
    return all

def kw_complete(match):
    return [ {"abbr": kw, "word" : kw[len(match):],"info" : "keyword " + kw } for kw in kwlist if kw.startswith(match) ]


class Completer(object):
    def __init__(self):
       self.compldict = {}
       self.parser = PyParser()

    def evalsource(self,text,line=0):
        sc = self.parser.parse(text,line)
        src = sc.get_code()
        dbg("source: %s" % src)
        try: exec(src) in self.compldict
        except: dbg("parser: %s, %s" % (sys.exc_info()[0],sys.exc_info()[1]))
        for l in sc.locals:
            try: exec(l) in self.compldict
            except: dbg("locals: %s, %s [%s]" % (sys.exc_info()[0],sys.exc_info()[1],l))

    def _cleanstr(self,doc):
        return doc.replace('"',' ').replace("'",' ')

    def get_arguments(self,func_obj):
        def _ctor(obj):
            try: return class_ob.__init__.im_func
            except AttributeError:
                for base in class_ob.__bases__:
                    rc = _find_constructor(base)
                    if rc is not None: return rc
            return None

        arg_offset = 1
        if type(func_obj) == types.ClassType: func_obj = _ctor(func_obj)
        elif type(func_obj) == types.MethodType: func_obj = func_obj.im_func
        else: arg_offset = 0

        arg_text=''
        if type(func_obj) in [types.FunctionType, types.LambdaType]:
            try:
                cd = func_obj.func_code
                real_args = cd.co_varnames[arg_offset:cd.co_argcount]
                defaults = func_obj.func_defaults or ''
                defaults = map(lambda name: "=%s" % name, defaults)
                defaults = [""] * (len(real_args)-len(defaults)) + defaults
                items = map(lambda a,d: a+d, real_args, defaults)
                if func_obj.func_code.co_flags & 0x4:
                    items.append("...")
                if func_obj.func_code.co_flags & 0x8:
                    items.append("***")
                arg_text = (','.join(items)) + ')'

            except:
                dbg("arg completion: %s: %s" % (sys.exc_info()[0],sys.exc_info()[1]))
                pass
        if len(arg_text) == 0:
            # The doc string sometimes contains the function signature
            #  this works for alot of C modules that are part of the
            #  standard library
            doc = func_obj.__doc__
            if doc:
                doc = doc.lstrip()
                pos = doc.find('\n')
                if pos > 0:
                    sigline = doc[:pos]
                    lidx = sigline.find('(')
                    ridx = sigline.find(')')
                    if lidx > 0 and ridx > 0:
                        arg_text = sigline[lidx+1:ridx] + ')'
        if len(arg_text) == 0: arg_text = ')'
        return arg_text

    def get_completions(self,context,match):
        dbg("get_completions('%s','%s')" % (context,match))
        stmt = ''
        if context: stmt += str(context)
        if match: stmt += str(match)
        try:
            result = None
            all = {}
            ridx = stmt.rfind('.')
            if len(stmt) > 0 and stmt[-1] == '(':
                result = eval(_sanitize(stmt[:-1]), self.compldict)
                doc = result.__doc__
                if doc == None: doc = ''
                args = self.get_arguments(result)
                return [{'word':self._cleanstr(args),'info':self._cleanstr(doc)}]
            elif ridx == -1:
                match = stmt
                all = self.compldict
            else:
                match = stmt[ridx+1:]
                stmt = _sanitize(stmt[:ridx])
                result = eval(stmt, self.compldict)
                all = dir(result)

            dbg("completing: stmt:%s" % stmt)
            completions = []

            try: maindoc = result.__doc__
            except: maindoc = ' '
            if maindoc == None: maindoc = ' '
            for m in all:
                if m == "_PyCmplNoType": continue #this is internal
                try:
                    dbg('possible completion: %s' % m)
                    if m.find(match) == 0:
                        if result == None: inst = all[m]
                        else: inst = getattr(result,m)
                        try: doc = inst.__doc__
                        except: doc = maindoc
                        typestr = str(inst)
                        if doc == None or doc == '': doc = maindoc

                        wrd = m[len(match):]
                        c = {'word':wrd, 'abbr':m,  'info':self._cleanstr(doc)}
                        if "function" in typestr:
                            c['word'] += '('
                            c['abbr'] += '(' + self._cleanstr(self.get_arguments(inst))
                        elif "method" in typestr:
                            c['word'] += '('
                            c['abbr'] += '(' + self._cleanstr(self.get_arguments(inst))
                        elif "module" in typestr:
                            c['word'] += '.'
                        elif "class" in typestr:
                            c['word'] += '('
                            c['abbr'] += '('
                        completions.append(c)
                except:
                    i = sys.exc_info()
                    dbg("inner completion: %s,%s [stmt='%s']" % (i[0],i[1],stmt))
            return completions
        except:
            i = sys.exc_info()
            dbg("completion: %s,%s [stmt='%s']" % (i[0],i[1],stmt))
            return []

class Scope(object):
    def __init__(self,name,indent):
        self.subscopes = []
        self.docstr = ''
        self.locals = []
        self.parent = None
        self.name = name
        self.indent = indent

    def add(self,sub):
        #print 'push scope: [%s@%s]' % (sub.name,sub.indent)
        sub.parent = self
        self.subscopes.append(sub)
        return sub

    def doc(self,str):
        """ Clean up a docstring """
        d = str.replace('\n',' ')
        d = d.replace('\t',' ')
        while d.find('  ') > -1: d = d.replace('  ',' ')
        while d[0] in '"\'\t ': d = d[1:]
        while d[-1] in '"\'\t ': d = d[:-1]
        self.docstr = d

    def local(self,loc):
        if not self._hasvaralready(loc):
            self.locals.append(loc)

    def copy_decl(self,indent=0):
        """ Copy a scope's declaration only, at the specified indent level - not local variables """
        return Scope(self.name,indent)

    def _hasvaralready(self,test):
        "Convienance function... keep out duplicates"
        if test.find('=') > -1:
            var = test.split('=')[0].strip()
            for l in self.locals:
                if l.find('=') > -1 and var == l.split('=')[0].strip():
                    return True
        return False

    def get_code(self):
        # we need to start with this, to fix up broken completions
        # hopefully this name is unique enough...
        str = '"""'+self.docstr+'"""\n'
        for l in self.locals:
            if l.startswith('import'): str += l+'\n'
        str += 'class _PyCmplNoType:\n    def __getattr__(self,name):\n        return None\n'
        for sub in self.subscopes:
            str += sub.get_code()
        for l in self.locals:
            if not l.startswith('import'): str += l+'\n'

        return str

    def pop(self,indent):
        #print 'pop scope: [%s] to [%s]' % (self.indent,indent)
        outer = self
        while outer.parent != None and outer.indent >= indent:
            outer = outer.parent
        return outer

    def currentindent(self):
        #print 'parse current indent: %s' % self.indent
        return '    '*self.indent

    def childindent(self):
        #print 'parse child indent: [%s]' % (self.indent+1)
        return '    '*(self.indent+1)

class Class(Scope):
    def __init__(self, name, supers, indent):
        Scope.__init__(self,name,indent)
        self.supers = supers
    def copy_decl(self,indent=0):
        c = Class(self.name,self.supers,indent)
        c.docstr = self.docstr
        c.locals = self.locals
        for s in self.subscopes:
            c.add(s.copy_decl(indent+1))
        return c
    def get_code(self):
        str = '%sclass %s' % (self.currentindent(),self.name)
        if len(self.supers) > 0: str += '(%s)' % ','.join(self.supers)
        str += ':\n'
        if len(self.docstr) > 0: str += self.childindent()+'"""'+self.docstr+'"""\n'
        if len(self.subscopes) > 0:
            for s in self.subscopes: str += s.get_code()
        else:
            str += '%spass\n' % self.childindent()
        for l in self.locals:
            str += '%s%s\n' % (self.childindent(),l)
        return str


class Function(Scope):
    def __init__(self, name, params, indent):
        Scope.__init__(self,name,indent)
        self.params = params
    def copy_decl(self,indent=0):
        f = Function(self.name,self.params,indent)
        f.docstr = self.docstr
        f.locals = self.locals
        return f
    def get_code(self):
        str = "%sdef %s(%s):\n" % \
            (self.currentindent(),self.name,','.join(self.params))
        if len(self.docstr) > 0: str += self.childindent()+'"""'+self.docstr+'"""\n'
        for l in self.locals:
            if isinstance(self.parent, Class) and l.startswith('self'):
                self.parent.local(l[5:])
            str += '%s%s\n' % (self.childindent(),l)
        str += "%spass\n" % self.childindent()
        return str

class PyParser:
    def __init__(self):
        self.top = Scope('global',0)
        self.scope = self.top
        self.lvaleu = None

    def _parsedotname(self,pre=None):
        #returns (dottedname, nexttoken)
        name = []
        if pre == None:
            tokentype, token, indent = self.next()
            if tokentype != NAME and token != '*':
                return ('', token)
        else: token = pre
        name.append(token)
        while True:
            tokentype, token, indent = self.next()
            if token != '.': break
            tokentype, token, indent = self.next()
            if tokentype != NAME: break
            name.append(token)
        return (".".join(name), token)

    def _parseimportlist(self):
        imports = []
        while True:
            name, token = self._parsedotname()
            if not name: break
            name2 = ''
            if token == 'as': name2, token = self._parsedotname()
            imports.append((name, name2))
            while token != "," and "\n" not in token:
                tokentype, token, indent = self.next()
            if token != ",": break
        return imports

    def _parenparse(self):
        name = ''
        names = []
        level = 1
        while True:
            tokentype, token, indent = self.next()
            if token in (')', ',') and level == 1:
                names.append(name)
                name = ''
            if token == '(':
                level += 1
            elif token == ')':
                level -= 1
                if level == 0: break
            elif token == ',' and level == 1:
                pass
            else:
                name += str(token)
        return names

    def _parsefunction(self,indent):
        self.scope=self.scope.pop(indent)
        tokentype, fname, ind = self.next()
        if tokentype != NAME: return None

        tokentype, open, ind = self.next()
        if open != '(': return None
        params=self._parenparse()

        tokentype, colon, ind = self.next()
        if colon != ':': return None

        return Function(fname,params,indent)

    def _parseclass(self,indent):
        self.scope=self.scope.pop(indent)
        tokentype, cname, ind = self.next()
        if tokentype != NAME: return None

        super = []
        tokentype, next, ind = self.next()
        if next == '(':
            super=self._parenparse()
        elif next != ':': return None

        return Class(cname,super,indent)

    def _parseassignment(self):
        assign=''
        tokentype, token, indent = self.next()
        if tokentype == tokenize.STRING or token == 'str':
            return '""'
        elif token == '(' or token == 'tuple':
            return '()'
        elif token == '[' or token == 'list':
            return '[]'
        elif token == '{' or token == 'dict':
            return '{}'
        elif tokentype == tokenize.NUMBER:
            return '0'
        elif token == 'open' or token == 'file':
            return 'file'
        elif token == 'None':
            return '_PyCmplNoType()'
        elif token == 'type':
            return 'type(_PyCmplNoType)' #only for method resolution
        else:
            assign += token
            level = 0
            while True:
                tokentype, token, indent = self.next()
                if token in ('(','{','['):
                    level += 1
                elif token in (']','}',')'):
                    level -= 1
                    if level == 0: break
                elif level == 0:
                    if token in (';','\n'): break
                    assign += token
        return "%s" % assign

    def next(self):
        type, token, (lineno, indent), end, self.parserline = self.gen.next()
        if lineno == self.curline:
            #print 'line found [%s] scope=%s' % (line.replace('\n',''),self.scope.name)
            self.currentscope = self.scope
        return (type, token, indent)

    def _adjustvisibility(self):
        newscope = Scope('result',0)
        scp = self.currentscope
        while scp != None:
            if type(scp) == Function:
                slice = 0
                #Handle 'self' params
                if scp.parent != None and type(scp.parent) == Class:
                    slice = 1
                    p = scp.params[0]
                    i = p.find('=')
                    if i != -1: p = p[:i]
                    newscope.local('%s = %s' % (scp.params[0],scp.parent.name))
                for p in scp.params[slice:]:
                    i = p.find('=')
                    if i == -1:
                        newscope.local('%s = _PyCmplNoType()' % p)
                    else:
                        newscope.local('%s = %s' % (p[:i],_sanitize(p[i+1])))

            for s in scp.subscopes:
                ns = s.copy_decl(0)
                newscope.add(ns)
            for l in scp.locals: newscope.local(l)
            scp = scp.parent


        self.currentscope = newscope

        return self.currentscope

    #p.parse(vim.current.buffer[:],vim.eval("line('.')"))
    def parse(self,text,curline=0):
        self.curline = int(curline)
        buf = cStringIO.StringIO(''.join(text) + '\n')
        self.gen = tokenize.generate_tokens(buf.readline)
        self.currentscope = self.scope

        try:
            freshscope=True
            while True:
                tokentype, token, indent = self.next()
                #dbg( 'main: token=[%s] indent=[%s]' % (token,indent))

                if tokentype == DEDENT or token == "pass":
                    self.scope = self.scope.pop(indent)
                elif token == 'def':
                    func = self._parsefunction(indent)
                    if func == None:
                        print "function: syntax error..."
                        continue
                    freshscope = True
                    self.scope = self.scope.add(func)
                elif token == 'class':
                    cls = self._parseclass(indent)
                    if cls == None:
                        print "class: syntax error..."
                        continue
                    freshscope = True
                    self.scope = self.scope.add(cls)

                elif token == 'import':
                    imports = self._parseimportlist()
                    for mod, alias in imports:
                        loc = "import %s" % mod
                        if len(alias) > 0: loc += " as %s" % alias
                        self.scope.local(loc)
                    freshscope = False
                elif token == 'from':
                    mod, token = self._parsedotname()
                    if not mod or token != "import":
                        print "from: syntax error..."
                        continue
                    names = self._parseimportlist()
                    for name, alias in names:
                        loc = "from %s import %s" % (mod,name)
                        if len(alias) > 0: loc += " as %s" % alias
                        self.scope.local(loc)
                    freshscope = False
                elif tokentype == STRING:
                    if freshscope: self.scope.doc(token)
                elif tokentype == NAME:
                    self.lvalue = token
                    name,token = self._parsedotname(token)
                    if token == '=':
                        stmt = self._parseassignment()
                        if stmt != None:
                            self.scope.local("%s = %s" % (name,stmt))
                    freshscope = False
        except StopIteration: #thrown on EOF
            pass
        except:
            dbg("parse error: %s, %s @ %s" %
                (sys.exc_info()[0], sys.exc_info()[1], self.parserline))
        return self._adjustvisibility()

def _sanitize(str):
    val = ''
    level = 0
    for c in str:
        if c in ('(','{','['):
            level += 1
        elif c in (']','}',')'):
            level -= 1
        elif level == 0:
            val += c
    return val

sys.path.extend(['.','..'])
