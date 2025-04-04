// This file is auto-generated by ./bin/rails stimulus:manifest:update
// Run that command whenever you add a new controller or create them with
// ./bin/rails generate stimulus controllerName

import { application } from "./application"

import HelloController from "./hello_controller"
application.register("hello", HelloController)

import SortableController from "./sortable_controller"
application.register("sortable", SortableController)

import SubtaskController from "./subtask_controller"
application.register("subtask", SubtaskController)

import TodoController from "./todo_controller"
application.register("todo", TodoController)
