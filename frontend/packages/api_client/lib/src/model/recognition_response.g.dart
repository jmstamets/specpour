// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'recognition_response.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$RecognitionResponse extends RecognitionResponse {
  @override
  final bool recognized;
  @override
  final String? candidateIngredientId;
  @override
  final ManualEntryForm manualEntryForm;

  factory _$RecognitionResponse(
          [void Function(RecognitionResponseBuilder)? updates]) =>
      (RecognitionResponseBuilder()..update(updates))._build();

  _$RecognitionResponse._(
      {required this.recognized,
      this.candidateIngredientId,
      required this.manualEntryForm})
      : super._();
  @override
  RecognitionResponse rebuild(
          void Function(RecognitionResponseBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  RecognitionResponseBuilder toBuilder() =>
      RecognitionResponseBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is RecognitionResponse &&
        recognized == other.recognized &&
        candidateIngredientId == other.candidateIngredientId &&
        manualEntryForm == other.manualEntryForm;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, recognized.hashCode);
    _$hash = $jc(_$hash, candidateIngredientId.hashCode);
    _$hash = $jc(_$hash, manualEntryForm.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'RecognitionResponse')
          ..add('recognized', recognized)
          ..add('candidateIngredientId', candidateIngredientId)
          ..add('manualEntryForm', manualEntryForm))
        .toString();
  }
}

class RecognitionResponseBuilder
    implements Builder<RecognitionResponse, RecognitionResponseBuilder> {
  _$RecognitionResponse? _$v;

  bool? _recognized;
  bool? get recognized => _$this._recognized;
  set recognized(bool? recognized) => _$this._recognized = recognized;

  String? _candidateIngredientId;
  String? get candidateIngredientId => _$this._candidateIngredientId;
  set candidateIngredientId(String? candidateIngredientId) =>
      _$this._candidateIngredientId = candidateIngredientId;

  ManualEntryFormBuilder? _manualEntryForm;
  ManualEntryFormBuilder get manualEntryForm =>
      _$this._manualEntryForm ??= ManualEntryFormBuilder();
  set manualEntryForm(ManualEntryFormBuilder? manualEntryForm) =>
      _$this._manualEntryForm = manualEntryForm;

  RecognitionResponseBuilder() {
    RecognitionResponse._defaults(this);
  }

  RecognitionResponseBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _recognized = $v.recognized;
      _candidateIngredientId = $v.candidateIngredientId;
      _manualEntryForm = $v.manualEntryForm.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(RecognitionResponse other) {
    _$v = other as _$RecognitionResponse;
  }

  @override
  void update(void Function(RecognitionResponseBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  RecognitionResponse build() => _build();

  _$RecognitionResponse _build() {
    _$RecognitionResponse _$result;
    try {
      _$result = _$v ??
          _$RecognitionResponse._(
            recognized: BuiltValueNullFieldError.checkNotNull(
                recognized, r'RecognitionResponse', 'recognized'),
            candidateIngredientId: candidateIngredientId,
            manualEntryForm: manualEntryForm.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'manualEntryForm';
        manualEntryForm.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'RecognitionResponse', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
