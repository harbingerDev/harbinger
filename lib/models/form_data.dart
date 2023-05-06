import 'package:flutter/material.dart';

import '../assets/constants.dart';

class FormData {
  final String name;
  final String type;
  final String defaultValue;
  final List<String>? values;

  FormData({
    required this.name,
    required this.type,
    required this.defaultValue,
    this.values,
  });
}

List<FormData> actionFormData = [
  FormData(name: 'Operated on', type: 'text', defaultValue: 'page'),
  FormData(
      name: 'Locator strategy1',
      type: 'list',
      defaultValue: 'null',
      values: availableLocatorStrategies),
  FormData(name: 'Locator value1', type: 'text', defaultValue: 'null'),
  FormData(
      name: 'Locator strategy2',
      type: 'list',
      defaultValue: 'null',
      values: availableLocatorStrategies),
  FormData(name: 'Locator value2', type: 'text', defaultValue: 'null'),
  FormData(
      name: 'Locator strategy3',
      type: 'list',
      defaultValue: 'null',
      values: availableLocatorStrategies),
  FormData(name: 'Locator value3', type: 'text', defaultValue: 'null'),
  FormData(
      name: 'Action',
      type: 'list',
      defaultValue: 'null',
      values: availableActions),
  FormData(name: 'Action argument', type: 'text', defaultValue: 'null'),
  FormData(
      name: 'Is parameterised', type: 'checkbox', defaultValue: 'unchecked'),
];

List<FormData> verificationFormData = [
  FormData(name: 'Assertion', type: 'text', defaultValue: 'expect'),
  FormData(name: 'Value to be asserted', type: 'text', defaultValue: 'null'),
  FormData(
      name: 'Assertion strategy',
      type: 'list',
      defaultValue: 'null',
      values: ['null', 'toBe', 'toBeEqualTo']),
  FormData(name: 'Expected value', type: 'text', defaultValue: 'null'),
];
