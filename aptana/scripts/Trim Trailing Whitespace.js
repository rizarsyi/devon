/* Menu: Editors > Trim Trailing Whitespace
 * DOM: http://download.eclipse.org/technology/dash/update/org.eclipse.eclipsemonkey.lang.javascript
 * Listener: commandService().addExecutionListener(this);
 */

function main()
{
    var editor = editors.activeEditor;

    if (editor === undefined) {
        alert('No active editor!');
    } else {
        editor.beginCompoundChange();

        var result = editor.source.replace(/[ \t]*$/mg, '');

        if (result !== editor.source) {
            editor.applyEdit(0, editor.sourceLength, result);
            editor.save();
        }
        
        editor.endCompoundChange();
    }
}

/**
 * Returns a reference to the workspace command service
 */
function commandService()
{
    var commandServiceClass = Packages.org.eclipse.ui.commands.ICommandService;

    // Same as doing ICommandService.class
    var commandService = Packages.org.eclipse.ui.PlatformUI.getWorkbench().getAdapter(commandServiceClass);
    return commandService;
}

/**
* Called before any/every command is executed, so we must filter on command ID
*/
function preExecute(commandId, event) {}

function postExecuteSuccess(commandId, returnValue)
{
    if (commandId === "org.eclipse.ui.file.save") {
        main();
    }
}

function notHandled(commandId, exception) {}

function postExecuteFailure(commandId, exception) {}