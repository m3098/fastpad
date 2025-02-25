import 'package:bloc/bloc.dart';
import 'package:fastpad/hive/note_model.dart';

import 'package:fastpad/theme/app_themes.dart';
import 'package:fastpad/theme/app_fonts.dart';

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

part 'notes_event.dart';
part 'notes_state.dart';

class NotesBloc extends Bloc<NotesEvent, NotesState> {
  static List<NoteModel> notes = Hive.box<NoteModel>("notes").values.toList();
  static int currentFont = Hive.box("settings").get(0) ?? 5;
  static int currentTheme = Hive.box("settings").get(1) ?? 0;
  static double textSizeMultiplier =
      Hive.box("settings").get(2) == null ? 1.1 : Hive.box("settings").get(2);

  static bool isFastNote = false;

  NotesBloc()
      : super(NotesInitial(
          notes,
          appThemeData[currentTheme].copyWith(
              textTheme: TextTheme(
            headline1: appFonts[currentFont].copyWith(
                fontSize: 97 * textSizeMultiplier, letterSpacing: -1.5),
            headline2: appFonts[currentFont].copyWith(
                fontSize: 61 * textSizeMultiplier, letterSpacing: -0.5),
            headline3: appFonts[currentFont].copyWith(
              fontSize: 48 * textSizeMultiplier,
            ),
            headline4: appFonts[currentFont].copyWith(
                fontSize: 34 * textSizeMultiplier, letterSpacing: 0.25),
            headline5: appFonts[currentFont].copyWith(
              fontSize: 24 * textSizeMultiplier,
            ),
            headline6: appFonts[currentFont].copyWith(
                fontSize: 20 * textSizeMultiplier, letterSpacing: 0.15),
            subtitle1: appFonts[currentFont].copyWith(
                fontSize: 16 * textSizeMultiplier, letterSpacing: 0.15),
            subtitle2: appFonts[currentFont].copyWith(
                fontSize: 14 * textSizeMultiplier, letterSpacing: 0.1),
            bodyText1: appFonts[currentFont].copyWith(
                fontSize: 16 * textSizeMultiplier, letterSpacing: 0.5),
            bodyText2: appFonts[currentFont].copyWith(
                fontSize: 14 * textSizeMultiplier, letterSpacing: 0.25),
            button: appFonts[currentFont].copyWith(
                fontSize: 14 * textSizeMultiplier, letterSpacing: 1.25),
            caption: appFonts[currentFont].copyWith(
                fontSize: 12 * textSizeMultiplier, letterSpacing: 0.4),
            overline: appFonts[currentFont].copyWith(
                fontSize: 10 * textSizeMultiplier, letterSpacing: 1.5),
          ).apply(
                  bodyColor:
                      appThemeData[currentTheme].colorScheme.inverseSurface,
                  displayColor:
                      appThemeData[currentTheme].colorScheme.inverseSurface)),
          textSizeMultiplier,
        )) {
    on<NotesEvent>((event, emit) {
      if (event is NoteAddEvent) {
        notes.add(event.note);
        Hive.box<NoteModel>("notes").clear();

        for (var element in notes) {
          Hive.box<NoteModel>("notes").add(element);
        }
      } else if (event is NoteDeleteEvent) {
        notes.removeAt(event.id);
        Hive.box<NoteModel>("notes").clear();

        for (var element in notes) {
          Hive.box<NoteModel>("notes").add(element);
        }
      } else if (event is NoteEditEvent) {
        notes[event.id] = event.note;

        Hive.box<NoteModel>("notes").clear();

        for (var element in notes) {
          Hive.box<NoteModel>("notes").add(element);
        }
      } else if (event is ChangeThemeEvent) {
        currentTheme = event.idTheme;
        Hive.box("settings").put(1, currentTheme);
      } else if (event is ChangeFontEvent) {
        currentFont = event.idFont;
        Hive.box("settings").put(0, currentFont);
      } else if (event is ChangeTextSizeEvent) {
        textSizeMultiplier = event.size;
        Hive.box("settings").put(2, textSizeMultiplier);
      } else if (event is PinNoteEvent) {
        notes[event.id].isLock = !notes[event.id].isLock;
        Hive.box<NoteModel>("notes").clear();

        notes.sort((a, b) {
          if (a.isLock && !b.isLock) {
            return -1; // Перемещаем a в начало списка
          } else if (!a.isLock && b.isLock) {
            return 1; // Перемещаем b в начало списка
          } else {
            return 0; // Оставляем a и b в текущем порядке
          }
        });

        Hive.box<NoteModel>("notes").addAll(notes);
      }

      emit(NotesInitial(
        notes,
        appThemeData[currentTheme].copyWith(
            textTheme: TextTheme(
          headline1: appFonts[currentFont]
              .copyWith(fontSize: 97 * textSizeMultiplier, letterSpacing: -1.5),
          headline2: appFonts[currentFont]
              .copyWith(fontSize: 61 * textSizeMultiplier, letterSpacing: -0.5),
          headline3: appFonts[currentFont].copyWith(
            fontSize: 48 * textSizeMultiplier,
          ),
          headline4: appFonts[currentFont]
              .copyWith(fontSize: 34 * textSizeMultiplier, letterSpacing: 0.25),
          headline5: appFonts[currentFont].copyWith(
            fontSize: 24 * textSizeMultiplier,
          ),
          headline6: appFonts[currentFont]
              .copyWith(fontSize: 20 * textSizeMultiplier, letterSpacing: 0.15),
          subtitle1: appFonts[currentFont]
              .copyWith(fontSize: 16 * textSizeMultiplier, letterSpacing: 0.15),
          subtitle2: appFonts[currentFont]
              .copyWith(fontSize: 14 * textSizeMultiplier, letterSpacing: 0.1),
          bodyText1: appFonts[currentFont]
              .copyWith(fontSize: 16 * textSizeMultiplier, letterSpacing: 0.5),
          bodyText2: appFonts[currentFont]
              .copyWith(fontSize: 14 * textSizeMultiplier, letterSpacing: 0.25),
          button: appFonts[currentFont]
              .copyWith(fontSize: 14 * textSizeMultiplier, letterSpacing: 1.25),
          caption: appFonts[currentFont]
              .copyWith(fontSize: 12 * textSizeMultiplier, letterSpacing: 0.4),
          overline: appFonts[currentFont]
              .copyWith(fontSize: 10 * textSizeMultiplier, letterSpacing: 1.5),
        ).apply(
                bodyColor:
                    appThemeData[currentTheme].colorScheme.inverseSurface,
                displayColor:
                    appThemeData[currentTheme].colorScheme.inverseSurface)),
        textSizeMultiplier,
      ));
    });
  }
}
