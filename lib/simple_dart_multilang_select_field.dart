import 'dart:html';

import 'package:simple_dart_multilang_controller/simple_dart_multilang_controller.dart';
import 'package:simple_dart_select_field/simple_dart_select_field.dart';

class MultilangSelectField<T> extends SelectField<T> {
  final Map<String, String> _optionKeyMap = <String, String>{};

  @override
  void initOptions(List<T> options) {
    optionList = options;
    for (final optionElement in selectElement.options) {
      optionElement.remove();
    }
    for (final obj in options) {
      final langKey = adapter(obj);
      final option = multilangController.translate(langKey);
      _optionKeyMap[option] = langKey;
      selectElement.append(OptionElement()..text = option);
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
    final oldValue = value;
    for (final optionElement in selectElement.options) {
      optionElement.remove();
    }
    _optionKeyMap.clear();
    for (final obj in optionList) {
      final langKey = adapter(obj);
      final option = multilangController.translate(langKey);
      final optionElement = OptionElement()..text = option;
      selectElement.append(optionElement);
      _optionKeyMap[option] = langKey;
    }
    value = oldValue;
  }
}
