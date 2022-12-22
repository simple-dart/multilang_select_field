import 'dart:html';

import 'package:simple_dart_multilang_controller/simple_dart_multilang_controller.dart';
import 'package:simple_dart_select_field/simple_dart_select_field.dart';

class MultilangSelectField extends SelectField {
  final Map<String, String> _optionKeyMap = <String, String>{};

  @override
  void initOptions(List<String> options) {
    optionList = options;
    for (final optionElement in selectElement.options) {
      optionElement.remove();
    }
    for (final langKey in options) {
      final option = multilangController.translate(langKey);
      _optionKeyMap[option] = langKey;
      selectElement.append(OptionElement()..text = option);
    }
  }

  @override
  List<String> get value {
    assert(selectElement.options.length == optionList.length,
        'selectElementOptions is not actual(${selectElement.options.length} != ${optionList.length})');
    final ret = <String>[];
    for (var i = 0; i < optionList.length; i++) {
      if (selectElement.options[i].selected) {
        final option = optionList[i];
        ret.add(option);
      }
    }
    return ret;
  }

  @override
  set value(List<String> newValue) {
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
    for (final langKey in optionList) {
      final option = multilangController.translate(langKey);
      final optionElement = OptionElement()..text = option;
      selectElement.append(optionElement);
      _optionKeyMap[option] = langKey;
    }
    value = oldValue;
  }
}
