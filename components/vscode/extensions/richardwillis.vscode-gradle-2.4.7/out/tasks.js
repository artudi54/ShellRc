"use strict";
var __awaiter = (this && this.__awaiter) || function (thisArg, _arguments, P, generator) {
    function adopt(value) { return value instanceof P ? value : new P(function (resolve) { resolve(value); }); }
    return new (P || (P = Promise))(function (resolve, reject) {
        function fulfilled(value) { try { step(generator.next(value)); } catch (e) { reject(e); } }
        function rejected(value) { try { step(generator["throw"](value)); } catch (e) { reject(e); } }
        function step(result) { result.done ? resolve(result.value) : adopt(result.value).then(fulfilled, rejected); }
        step((generator = generator.apply(thisArg, _arguments || [])).next());
    });
};
var __importStar = (this && this.__importStar) || function (mod) {
    if (mod && mod.__esModule) return mod;
    var result = {};
    if (mod != null) for (var k in mod) if (Object.hasOwnProperty.call(mod, k)) result[k] = mod[k];
    result["default"] = mod;
    return result;
};
Object.defineProperty(exports, "__esModule", { value: true });
const vscode = __importStar(require("vscode"));
const path = __importStar(require("path"));
const config_1 = require("./config");
const logger_1 = require("./logger");
const stoppingTasks = new Set();
let autoDetectOverride = false;
let cachedTasks = [];
const emptyTasks = [];
function enableTaskDetection() {
    autoDetectOverride = true;
}
exports.enableTaskDetection = enableTaskDetection;
function getTaskExecution(task) {
    return vscode.tasks.taskExecutions.find(e => e.task === task);
}
exports.getTaskExecution = getTaskExecution;
function getGradleTaskExecutions() {
    return vscode.tasks.taskExecutions.filter(e => e.task.source === 'gradle');
}
exports.getGradleTaskExecutions = getGradleTaskExecutions;
function stopRunningGradleTasks() {
    const taskExecutions = getGradleTaskExecutions();
    taskExecutions.forEach(execution => {
        vscode.commands.executeCommand('gradle.stopTask', execution.task);
    });
}
exports.stopRunningGradleTasks = stopRunningGradleTasks;
function stopTask(task) {
    const execution = getTaskExecution(task);
    if (execution) {
        execution.terminate();
        stoppingTasks.add(task);
    }
}
exports.stopTask = stopTask;
function isTaskRunning(task) {
    return getTaskExecution(task) !== undefined;
}
exports.isTaskRunning = isTaskRunning;
function isTaskStopping(task) {
    return stoppingTasks.has(task);
}
exports.isTaskStopping = isTaskStopping;
function setStoppedTaskAsComplete(task, sourceDir) {
    const stoppingTask = Array.from(stoppingTasks).find(({ definition }) => definition.script === task && definition.projectFolder === sourceDir);
    if (stoppingTask) {
        stoppingTasks.delete(stoppingTask);
    }
}
exports.setStoppedTaskAsComplete = setStoppedTaskAsComplete;
function hasGradleBuildFile(folder) {
    return __awaiter(this, void 0, void 0, function* () {
        const relativePattern = new vscode.RelativePattern(folder.fsPath, '*{.gradle,.gradle.kts}');
        const files = yield vscode.workspace.findFiles(relativePattern);
        return files.length > 0;
    });
}
function getGradleProjectFolders(rootWorkspaceFolder) {
    return __awaiter(this, void 0, void 0, function* () {
        const gradleWrapperFiles = yield vscode.workspace.findFiles(new vscode.RelativePattern(rootWorkspaceFolder, '**/*{gradlew,gradlew.bat}'));
        const gradleWrapperFolders = Array.from(new Set(gradleWrapperFiles.map(file => path.dirname(file.fsPath)))).map(folder => vscode.Uri.file(folder));
        const gradleProjectFolders = [];
        for (const gradleWrapperFolder of gradleWrapperFolders) {
            if (yield hasGradleBuildFile(gradleWrapperFolder)) {
                gradleProjectFolders.push(gradleWrapperFolder);
            }
        }
        return gradleProjectFolders;
    });
}
class GradleTaskProvider {
    constructor(client) {
        this.client = client;
        this.refreshPromise = undefined;
    }
    provideTasks() {
        return __awaiter(this, void 0, void 0, function* () {
            return cachedTasks;
        });
    }
    // TODO
    resolveTask( /*
      _task: vscode.Task
    */) {
        return __awaiter(this, void 0, void 0, function* () {
            return undefined;
        });
    }
    refreshTasks(folders) {
        return __awaiter(this, void 0, void 0, function* () {
            const allTasks = [];
            try {
                for (const workspaceFolder of folders) {
                    if (autoDetectOverride || config_1.getIsAutoDetectionEnabled(workspaceFolder)) {
                        const projectFolders = yield getGradleProjectFolders(workspaceFolder);
                        for (const projectFolder of projectFolders) {
                            allTasks.push(...(yield this.provideGradleTasksForFolder(workspaceFolder, projectFolder)));
                        }
                    }
                }
                cachedTasks = allTasks;
            }
            catch (e) {
                cachedTasks = emptyTasks;
            }
        });
    }
    reset() {
        this.refreshPromise = undefined;
    }
    refresh() {
        return __awaiter(this, void 0, void 0, function* () {
            const folders = vscode.workspace.workspaceFolders;
            if (!folders) {
                cachedTasks = emptyTasks;
            }
            else {
                if (!this.refreshPromise) {
                    this.refreshPromise = this.refreshTasks(folders).finally(() => this.reset());
                }
                yield this.refreshPromise;
            }
            return cachedTasks;
        });
    }
    provideGradleTasksForFolder(workspaceFolder, projectFolder) {
        return __awaiter(this, void 0, void 0, function* () {
            const gradleTasks = yield this.getGradleTasks(projectFolder);
            if (!gradleTasks || !gradleTasks.length) {
                return emptyTasks;
            }
            return gradleTasks.map(gradleTask => this.createVSCodeTaskFromGradleTask(gradleTask, workspaceFolder, gradleTask.rootProject, vscode.Uri.file(gradleTask.buildFile), projectFolder));
        });
    }
    createVSCodeTaskFromGradleTask(gradleTask, workspaceFolder, rootProject, buildFile, projectFolder, args = '') {
        const script = gradleTask.path.replace(/^:/, '');
        const definition = {
            type: 'gradle',
            script,
            description: gradleTask.description,
            group: (gradleTask.group || 'other').toLowerCase(),
            project: gradleTask.project,
            buildFile: buildFile.fsPath,
            rootProject,
            projectFolder: projectFolder.fsPath,
            workspaceFolder: workspaceFolder.uri.fsPath,
            args
        };
        return createTaskFromDefinition(definition, workspaceFolder, projectFolder, this.client);
    }
    getGradleTasks(projectFolder) {
        var _a;
        return __awaiter(this, void 0, void 0, function* () {
            return (_a = this.client) === null || _a === void 0 ? void 0 : _a.getTasks(projectFolder.fsPath);
        });
    }
}
exports.GradleTaskProvider = GradleTaskProvider;
function invalidateTasksCache() {
    cachedTasks = emptyTasks;
}
exports.invalidateTasksCache = invalidateTasksCache;
// eslint-disable-next-line @typescript-eslint/no-explicit-any
function isWorkspaceFolder(value) {
    return value && typeof value !== 'number';
}
exports.isWorkspaceFolder = isWorkspaceFolder;
function getGradleTasksServerCommand() {
    const platform = process.platform;
    if (platform === 'win32') {
        return '.\\gradle-tasks.bat';
    }
    else if (platform === 'linux' || platform === 'darwin') {
        return './gradle-tasks';
    }
    else {
        throw new Error('Unsupported platform');
    }
}
exports.getGradleTasksServerCommand = getGradleTasksServerCommand;
function isTaskOfType(definition, type) {
    return (definition.group.toLowerCase() === type ||
        definition.script
            .split(' ')[0]
            .split(':')
            .pop() === type);
}
class CustomBuildTaskTerminal {
    constructor(client, sourceDir, task) {
        this.client = client;
        this.sourceDir = sourceDir;
        this.task = task;
        this.writeEmitter = new vscode.EventEmitter();
        this.onDidWrite = this.writeEmitter.event;
        this.closeEmitter = new vscode.EventEmitter();
        this.onDidClose = this.closeEmitter.event;
    }
    open() {
        this.doBuild();
    }
    close() {
        this.client.stopTask(this.sourceDir, this.task.definition.script);
    }
    doBuild() {
        return __awaiter(this, void 0, void 0, function* () {
            const args = this.task.definition.args.split(' ').filter(Boolean);
            try {
                yield this.client.runTask(this.sourceDir, this.task.definition.script, args, (message) => {
                    var _a;
                    this.writeEmitter.fire(((_a = message.message) === null || _a === void 0 ? void 0 : _a.toString()) + '\r\n');
                });
            }
            finally {
                setTimeout(() => {
                    this.closeEmitter.fire();
                }, 100); // give the UI some time to render the terminal
            }
        });
    }
    handleInput(data) {
        if (data === '\x03') {
            vscode.commands.executeCommand('gradle.stopTask', this.task);
        }
    }
}
function createTaskFromDefinition(definition, workspaceFolder, projectFolder, client) {
    let taskName = definition.script;
    if (definition.projectFolder !== definition.workspaceFolder) {
        const relativePath = path.relative(definition.workspaceFolder, definition.projectFolder);
        taskName += ` - ${relativePath}`;
    }
    const task = new vscode.Task(definition, workspaceFolder, taskName, 'gradle', new vscode.CustomExecution(() => __awaiter(this, void 0, void 0, function* () {
        return new CustomBuildTaskTerminal(client, projectFolder.fsPath, task);
    })), ['$gradle']);
    task.presentationOptions = {
        clear: true,
        showReuseMessage: false,
        focus: true,
        panel: vscode.TaskPanelKind.Shared,
        reveal: vscode.TaskRevealKind.Always
    };
    if (isTaskOfType(definition, 'build')) {
        task.group = vscode.TaskGroup.Build;
    }
    if (isTaskOfType(definition, 'test')) {
        task.group = vscode.TaskGroup.Test;
    }
    return task;
}
exports.createTaskFromDefinition = createTaskFromDefinition;
function cloneTask(task, args, client) {
    return __awaiter(this, void 0, void 0, function* () {
        const folder = task.scope;
        const definition = Object.assign(Object.assign({}, task.definition), { args });
        return createTaskFromDefinition(definition, folder, vscode.Uri.file(definition.projectFolder), client);
    });
}
exports.cloneTask = cloneTask;
function buildGradleServerTask(taskName, cwd, args = []) {
    const cmd = `"${getGradleTasksServerCommand()}"`;
    const taskType = 'gradle';
    const definition = {
        type: taskType
    };
    if (config_1.getIsDebugEnabled()) {
        logger_1.logger.debug(`Gradle Server Tasks dir: ${cwd}`);
        logger_1.logger.debug(`Gradle Server Tasks cmd: ${cmd} ${args}`);
    }
    const task = new vscode.Task(definition, vscode.TaskScope.Workspace, taskName, taskType, new vscode.ShellExecution(cmd, args, { cwd }));
    task.isBackground = true;
    task.source = taskType;
    task.presentationOptions = {
        reveal: vscode.TaskRevealKind.Never,
        focus: false,
        echo: true,
        clear: false,
        panel: vscode.TaskPanelKind.Shared
    };
    return task;
}
exports.buildGradleServerTask = buildGradleServerTask;
function handleCancelledTaskMessage(message) {
    setStoppedTaskAsComplete(message.task, message.sourceDir);
    logger_1.logger.info(`Task cancelled: ${message.message}`);
    vscode.commands.executeCommand('gradle.explorerRender');
}
exports.handleCancelledTaskMessage = handleCancelledTaskMessage;
function registerTaskProvider(context, client) {
    function refreshTasks() {
        vscode.commands.executeCommand('gradle.refresh', false);
    }
    const buildFileGlob = `**/*.{gradle,gradle.kts}`;
    const watcher = vscode.workspace.createFileSystemWatcher(buildFileGlob);
    context.subscriptions.push(watcher);
    watcher.onDidChange(refreshTasks);
    watcher.onDidDelete(refreshTasks);
    watcher.onDidCreate(refreshTasks);
    context.subscriptions.push(vscode.workspace.onDidChangeWorkspaceFolders(refreshTasks));
    const provider = new GradleTaskProvider(client);
    const taskProvider = vscode.tasks.registerTaskProvider('gradle', provider);
    context.subscriptions.push(taskProvider);
    return provider;
}
exports.registerTaskProvider = registerTaskProvider;
//# sourceMappingURL=tasks.js.map