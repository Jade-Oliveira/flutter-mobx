import 'package:mobx/mobx.dart';
import 'package:todomobx/stores/todo_store.dart';
part 'list_store.g.dart';

class ListStore = _ListStoreBase with _$ListStore;

abstract class _ListStoreBase with Store {
  @observable
  String newTodoTitle = '';

  @action
  void setNewTodoTitle(String value) => newTodoTitle = value;

  @computed
  bool get isFormValid => newTodoTitle.isNotEmpty;

  //lista com um observable interno que vai perceber a modificação quando adicionarmos algo nela
  ObservableList<ToDoStore> todoList = ObservableList<ToDoStore>();

  //com o insert ao invés do add eu coloco na posição que quiser o meu item quando adiciono na lista
  void addTodo() {
    todoList.insert(0, ToDoStore(newTodoTitle));
    //reseto o texto para o botão de add não aparecer sem texto
    newTodoTitle = '';
  }
}
