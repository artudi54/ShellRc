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
const path = __importStar(require("path"));
const vscode = __importStar(require("vscode"));
const tasks_1 = require("./tasks");
function treeItemSortCompareFunc(a, b) {
    return a.label.localeCompare(b.label);
}
class WorkspaceTreeItem extends vscode.TreeItem {
    constructor(name, resourceUri) {
        super(name, vscode.TreeItemCollapsibleState.Expanded);
        this.projects = [];
        this.projectFolders = [];
        this.parentTreeItem = null;
        this.contextValue = 'folder';
        this.resourceUri = resourceUri;
        this.iconPath = vscode.ThemeIcon.Folder;
    }
    addProject(project) {
        this.projects.push(project);
    }
    addProjectFolder(projectFolder) {
        this.projectFolders.push(projectFolder);
    }
}
class TreeItemWithTasksOrGroups extends vscode.TreeItem {
    constructor(name, parentTreeItem, resourceUri, collapsibleState = vscode.TreeItemCollapsibleState.Expanded) {
        super(name, collapsibleState);
        this._tasks = [];
        this._groups = [];
        this.iconPath = vscode.ThemeIcon.Folder;
        this.contextValue = 'folder';
        this.resourceUri = resourceUri;
        this.parentTreeItem = parentTreeItem;
    }
    addTask(task) {
        this._tasks.push(task);
    }
    get tasks() {
        return this._tasks.sort(treeItemSortCompareFunc);
    }
    addGroup(group) {
        this._groups.push(group);
    }
    get groups() {
        return this._groups.sort(treeItemSortCompareFunc);
    }
}
class ProjectTreeItem extends TreeItemWithTasksOrGroups {
    constructor() {
        super(...arguments);
        this.iconPath = vscode.ThemeIcon.File;
    }
}
class GroupTreeItem extends TreeItemWithTasksOrGroups {
    constructor(name, parentTreeItem, resourceUri) {
        super(name, parentTreeItem, resourceUri, vscode.TreeItemCollapsibleState.Collapsed);
    }
}
function getTreeItemState(task) {
    if (tasks_1.isTaskRunning(task)) {
        return GradleTaskTreeItem.STATE_RUNNING;
    }
    if (tasks_1.isTaskStopping(task)) {
        return GradleTaskTreeItem.STATE_STOPPING;
    }
    return GradleTaskTreeItem.STATE_IDLE;
}
class GradleTaskTreeItem extends vscode.TreeItem {
    constructor(context, parentTreeItem, task, label, description) {
        super(label, vscode.TreeItemCollapsibleState.None);
        this.command = {
            title: 'Run Task',
            command: 'gradle.openBuildFile',
            arguments: [this]
        };
        this.tooltip = description || label;
        this.parentTreeItem = parentTreeItem;
        this.task = task;
        this.contextValue = getTreeItemState(task);
        if (this.contextValue === GradleTaskTreeItem.STATE_RUNNING) {
            this.iconPath = {
                light: context.asAbsolutePath(path.join('resources', 'light', 'loading.svg')),
                dark: context.asAbsolutePath(path.join('resources', 'dark', 'loading.svg'))
            };
        }
        else {
            this.iconPath = {
                light: context.asAbsolutePath(path.join('resources', 'light', 'script.svg')),
                dark: context.asAbsolutePath(path.join('resources', 'dark', 'script.svg'))
            };
        }
    }
}
exports.GradleTaskTreeItem = GradleTaskTreeItem;
GradleTaskTreeItem.STATE_RUNNING = 'runningTask';
GradleTaskTreeItem.STATE_STOPPING = 'stoppingTask';
GradleTaskTreeItem.STATE_IDLE = 'task';
class NoTasksTreeItem extends vscode.TreeItem {
    constructor() {
        super('No tasks found', vscode.TreeItemCollapsibleState.None);
        this.contextValue = 'notasks';
    }
}
class GradleTasksTreeDataProvider {
    constructor(extensionContext, collapsed = true, client) {
        this.extensionContext = extensionContext;
        this.collapsed = collapsed;
        this.client = client;
        this.taskItems = [];
        this.taskTree = null;
        this._onDidChangeTreeData = new vscode.EventEmitter();
        this.onDidChangeTreeData = this
            ._onDidChangeTreeData.event;
        extensionContext.subscriptions.push(vscode.tasks.onDidStartTask(this.onTaskStatusChange, this));
        extensionContext.subscriptions.push(vscode.tasks.onDidEndTask(this.onTaskStatusChange, this));
        this.setCollapsed(collapsed);
    }
    setCollapsed(collapsed) {
        this.collapsed = collapsed;
        this.extensionContext.workspaceState.update('explorerCollapsed', collapsed);
        vscode.commands.executeCommand('setContext', 'gradle:explorerCollapsed', collapsed);
        this.render();
    }
    onTaskStatusChange(event) {
        this.taskTree = null;
        this._onDidChangeTreeData.fire(event.execution.task.definition.treeItem);
    }
    runTask(taskItem) {
        if (taskItem && taskItem.task) {
            vscode.tasks.executeTask(taskItem.task);
        }
    }
    runTaskWithArgs(taskItem) {
        return __awaiter(this, void 0, void 0, function* () {
            if (taskItem && taskItem.task) {
                const args = yield vscode.window.showInputBox({
                    placeHolder: 'For example: --all',
                    ignoreFocusOut: true
                });
                if (args !== undefined) {
                    const task = yield tasks_1.cloneTask(taskItem.task, args, this.client);
                    if (task) {
                        vscode.tasks.executeTask(task);
                    }
                }
            }
        });
    }
    refresh() {
        return __awaiter(this, void 0, void 0, function* () {
            // enableTaskDetection();
            // invalidateTasksCache();
            this.taskItems = yield vscode.tasks.fetchTasks({ type: 'gradle' });
            this.render();
        });
    }
    render() {
        this.taskTree = null;
        this._onDidChangeTreeData.fire();
    }
    getTreeItem(element) {
        return element;
    }
    getParent(element) {
        if (element instanceof WorkspaceTreeItem) {
            return element.parentTreeItem;
        }
        if (element instanceof ProjectTreeItem) {
            return element.parentTreeItem;
        }
        if (element instanceof TreeItemWithTasksOrGroups) {
            return element.parentTreeItem;
        }
        if (element instanceof GradleTaskTreeItem) {
            return element.parentTreeItem;
        }
        if (element instanceof NoTasksTreeItem) {
            return null;
        }
        return null;
    }
    getChildren(element) {
        return __awaiter(this, void 0, void 0, function* () {
            if (!this.taskTree) {
                if (this.taskItems.length === 0) {
                    this.taskTree = [new NoTasksTreeItem()];
                }
                else {
                    this.taskTree = this.buildTaskTree(this.taskItems);
                }
            }
            if (element instanceof WorkspaceTreeItem) {
                return [...element.projectFolders, ...element.projects];
            }
            if (element instanceof ProjectTreeItem) {
                return [...element.groups, ...element.tasks];
            }
            if (element instanceof GroupTreeItem) {
                return element.tasks;
            }
            if (element instanceof GradleTaskTreeItem) {
                return [];
            }
            if (element instanceof NoTasksTreeItem) {
                return [];
            }
            if (!element && this.taskTree) {
                return this.taskTree;
            }
            return [];
        });
    }
    // eslint-disable-next-line sonarjs/cognitive-complexity
    buildTaskTree(tasks) {
        const workspaceTreeItems = new Map();
        const nestedWorkspaceTreeItems = new Map();
        const projectTreeItems = new Map();
        const groupTreeItems = new Map();
        let workspaceTreeItem = null;
        tasks.forEach(task => {
            if (tasks_1.isWorkspaceFolder(task.scope)) {
                workspaceTreeItem = workspaceTreeItems.get(task.scope.name);
                if (!workspaceTreeItem) {
                    workspaceTreeItem = new WorkspaceTreeItem(task.scope.name, task.scope.uri);
                    workspaceTreeItems.set(task.scope.name, workspaceTreeItem);
                }
                if (task.definition.projectFolder !== task.definition.workspaceFolder) {
                    const relativePath = path.relative(task.definition.workspaceFolder, task.definition.projectFolder);
                    let nestedWorkspaceTreeItem = nestedWorkspaceTreeItems.get(relativePath);
                    if (!nestedWorkspaceTreeItem) {
                        nestedWorkspaceTreeItem = new WorkspaceTreeItem(relativePath, vscode.Uri.file(task.definition.projectFolder));
                        nestedWorkspaceTreeItems.set(relativePath, nestedWorkspaceTreeItem);
                        nestedWorkspaceTreeItem.parentTreeItem = workspaceTreeItem;
                        workspaceTreeItem.addProjectFolder(nestedWorkspaceTreeItem);
                    }
                    workspaceTreeItem = nestedWorkspaceTreeItem;
                }
                const projectName = this.collapsed
                    ? task.definition.rootProject
                    : task.definition.project;
                let projectTreeItem = projectTreeItems.get(projectName);
                if (!projectTreeItem) {
                    projectTreeItem = new ProjectTreeItem(projectName, workspaceTreeItem, vscode.Uri.file(task.definition.buildFile));
                    workspaceTreeItem.addProject(projectTreeItem);
                    projectTreeItems.set(projectName, projectTreeItem);
                }
                let taskName = task.definition.script;
                let parentTreeItem = projectTreeItem;
                if (!this.collapsed) {
                    const groupId = task.definition.group + task.definition.project;
                    let groupTreeItem = groupTreeItems.get(groupId);
                    if (!groupTreeItem) {
                        groupTreeItem = new GroupTreeItem(task.definition.group, workspaceTreeItem, undefined);
                        projectTreeItem.addGroup(groupTreeItem);
                        groupTreeItems.set(groupId, groupTreeItem);
                    }
                    parentTreeItem = groupTreeItem;
                    taskName = task.definition.script.split(':').pop();
                }
                parentTreeItem.addTask(new GradleTaskTreeItem(this.extensionContext, parentTreeItem, task, taskName, task.definition.description));
            }
        });
        if (workspaceTreeItems.size === 1) {
            return [
                ...workspaceTreeItems.values().next().value.projectFolders,
                ...workspaceTreeItems.values().next().value.projects
            ];
        }
        return [...workspaceTreeItems.values()];
    }
}
exports.GradleTasksTreeDataProvider = GradleTasksTreeDataProvider;
function registerExplorer(context, client) {
    const collapsed = context.workspaceState.get('explorerCollapsed', false);
    const treeDataProvider = new GradleTasksTreeDataProvider(context, collapsed, client);
    context.subscriptions.push(vscode.window.createTreeView('gradleTreeView', {
        treeDataProvider: treeDataProvider,
        showCollapseAll: true
    }));
    return treeDataProvider;
}
exports.registerExplorer = registerExplorer;
//# sourceMappingURL=gradleView.js.map