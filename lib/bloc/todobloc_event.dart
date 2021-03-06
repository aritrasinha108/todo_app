part of 'todobloc_bloc.dart';

abstract class TodoblocEvent extends Equatable {
  const TodoblocEvent();
}

// event trigerred to get the to-do list
class GetTodoEvent extends TodoblocEvent {
  DateTime selectedDate;

  GetTodoEvent(this.selectedDate);

  @override
  // TODO: implement props
  List<Object> get props =>
      [selectedDate.day, selectedDate.month, selectedDate.year];
}

//For adding the todo
class AddTodoEvent extends TodoblocEvent {
  Todo entry;
  NotificationManager manager;

  AddTodoEvent({this.entry, this.manager});

  @override
  // TODO: implement props
  List<Object> get props => [
        entry.title,
        entry.completed,
        entry.date.day,
        entry.date.month,
        entry.date.year,
      ];
}

//For editing the todo
class EditTodoEvent extends TodoblocEvent {
  int index;
  Todo entry;
  NotificationManager manager;

  EditTodoEvent({this.index, this.entry, this.manager});

  @override
  // TODO: implement props
  List<Object> get props => [entry.title, index];
}

//For deleting the todo
class DeleteTodoEvent extends TodoblocEvent {
  int index;
  Todo entry;
  NotificationManager manager;

  DeleteTodoEvent({this.index, this.entry, this.manager});

  @override
  // TODO: implement props
  List<Object> get props => [index];
}

//For completing the todo
class CompleteTodoEvent extends TodoblocEvent {
  int index;
  Todo entry;
    NotificationManager manager;

  CompleteTodoEvent({this.index, this.entry, this.manager});

  @override
  // TODO: implement props
  List<Object> get props => [entry.completed.toString(), index];
}
class ShiftTodoEvent extends TodoblocEvent
{
  int index;
  NotificationManager manager;
  DateTime previousDate;
  Todo entry;
  ShiftTodoEvent({this.index,this.manager,this.entry,this.previousDate});
  @override
  // TODO: implement props
  List<Object> get props => [entry.date.toString(),index];
}

