import 'dart:html';

import 'package:simple_dart_multilang_controller/simple_dart_multilang_controller.dart';
import 'package:simple_dart_select_field/simple_dart_select_field.dart';

class MultilangSelectField<T> extends SelectField<T> {
  @override
  void initOptions(List<T> options) {
    optionList = options;
    for (final optionElement in selectElement.options) {
      optionElement.remove();
    }
    for (final obj in options) {
      final langKey = adapter(obj);
      final option = multilangController.translate(langKey);
      selectElement.append(OptionElement()..text = option);
    }
  }

  @override
  void initOptionsWithGroups(Map<String, List<T>> groups) {
    clear();
    for (final group in groups.entries) {
      final optGroup = OptGroupElement()..label = multilangController.translate(group.key);
      for (final option in group.value) {
        final langKey = adapter(option);
        final optionElement = OptionElement()
          ..text = multilangController.translate(langKey)
          ..value = multilangController.translate(langKey);
        optGroup.append(optionElement);
        optionList.add(option);
      }
      selectElement.append(optGroup);
    }
  }

  @override
  List<T> get value {
    assert(selectElement.options.length == optionList.length,
        'selectElementOptions is not actual(${selectElement.options.length} != ${optionList.length})');
    final ret = <T>[];
    for (var i = 0; i < optionList.length; i++) {
      if (selectElement.options[i].selected) {
        final option = optionList[i];
        ret.add(option);
      }
    }
    return ret;
  }

  @override
  set value(List<T> newValue) {
    final oldValue = value;
    for (var i = 0; i < optionList.length; i++) {
      final langKey = optionList[i];
      final optionVal = newValue.contains(langKey);
      selectElement.options[i].selected = optionVal;
    }
    fireValueChange(oldValue, newValue);
  }

  @override
  void reRender() {
    var i = 0;
    for (final optionElement in selectElement.options) {
      optionElement.text = multilangController.translate(adapter(optionList[i]));
      i++;
    }
  }
}
