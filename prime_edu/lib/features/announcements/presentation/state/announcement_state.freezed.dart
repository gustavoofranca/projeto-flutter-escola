// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'announcement_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$AnnouncementState {
  /// Indica se uma operação está em andamento
  bool get isLoading => throw _privateConstructorUsedError;

  /// Lista de anúncios
  List<AnnouncementEntity> get announcements =>
      throw _privateConstructorUsedError;

  /// Mensagem de erro, se houver
  String? get error => throw _privateConstructorUsedError;

  /// Indica se os dados foram carregados
  bool get isLoaded => throw _privateConstructorUsedError;

  /// Filtro atual aplicado
  AnnouncementFilter get filter => throw _privateConstructorUsedError;

  /// Create a copy of AnnouncementState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AnnouncementStateCopyWith<AnnouncementState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AnnouncementStateCopyWith<$Res> {
  factory $AnnouncementStateCopyWith(
    AnnouncementState value,
    $Res Function(AnnouncementState) then,
  ) = _$AnnouncementStateCopyWithImpl<$Res, AnnouncementState>;
  @useResult
  $Res call({
    bool isLoading,
    List<AnnouncementEntity> announcements,
    String? error,
    bool isLoaded,
    AnnouncementFilter filter,
  });
}

/// @nodoc
class _$AnnouncementStateCopyWithImpl<$Res, $Val extends AnnouncementState>
    implements $AnnouncementStateCopyWith<$Res> {
  _$AnnouncementStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AnnouncementState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isLoading = null,
    Object? announcements = null,
    Object? error = freezed,
    Object? isLoaded = null,
    Object? filter = null,
  }) {
    return _then(
      _value.copyWith(
            isLoading: null == isLoading
                ? _value.isLoading
                : isLoading // ignore: cast_nullable_to_non_nullable
                      as bool,
            announcements: null == announcements
                ? _value.announcements
                : announcements // ignore: cast_nullable_to_non_nullable
                      as List<AnnouncementEntity>,
            error: freezed == error
                ? _value.error
                : error // ignore: cast_nullable_to_non_nullable
                      as String?,
            isLoaded: null == isLoaded
                ? _value.isLoaded
                : isLoaded // ignore: cast_nullable_to_non_nullable
                      as bool,
            filter: null == filter
                ? _value.filter
                : filter // ignore: cast_nullable_to_non_nullable
                      as AnnouncementFilter,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$AnnouncementStateImplCopyWith<$Res>
    implements $AnnouncementStateCopyWith<$Res> {
  factory _$$AnnouncementStateImplCopyWith(
    _$AnnouncementStateImpl value,
    $Res Function(_$AnnouncementStateImpl) then,
  ) = __$$AnnouncementStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    bool isLoading,
    List<AnnouncementEntity> announcements,
    String? error,
    bool isLoaded,
    AnnouncementFilter filter,
  });
}

/// @nodoc
class __$$AnnouncementStateImplCopyWithImpl<$Res>
    extends _$AnnouncementStateCopyWithImpl<$Res, _$AnnouncementStateImpl>
    implements _$$AnnouncementStateImplCopyWith<$Res> {
  __$$AnnouncementStateImplCopyWithImpl(
    _$AnnouncementStateImpl _value,
    $Res Function(_$AnnouncementStateImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of AnnouncementState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isLoading = null,
    Object? announcements = null,
    Object? error = freezed,
    Object? isLoaded = null,
    Object? filter = null,
  }) {
    return _then(
      _$AnnouncementStateImpl(
        isLoading: null == isLoading
            ? _value.isLoading
            : isLoading // ignore: cast_nullable_to_non_nullable
                  as bool,
        announcements: null == announcements
            ? _value._announcements
            : announcements // ignore: cast_nullable_to_non_nullable
                  as List<AnnouncementEntity>,
        error: freezed == error
            ? _value.error
            : error // ignore: cast_nullable_to_non_nullable
                  as String?,
        isLoaded: null == isLoaded
            ? _value.isLoaded
            : isLoaded // ignore: cast_nullable_to_non_nullable
                  as bool,
        filter: null == filter
            ? _value.filter
            : filter // ignore: cast_nullable_to_non_nullable
                  as AnnouncementFilter,
      ),
    );
  }
}

/// @nodoc

class _$AnnouncementStateImpl implements _AnnouncementState {
  const _$AnnouncementStateImpl({
    this.isLoading = false,
    final List<AnnouncementEntity> announcements = const [],
    this.error,
    this.isLoaded = false,
    this.filter = AnnouncementFilter.all,
  }) : _announcements = announcements;

  /// Indica se uma operação está em andamento
  @override
  @JsonKey()
  final bool isLoading;

  /// Lista de anúncios
  final List<AnnouncementEntity> _announcements;

  /// Lista de anúncios
  @override
  @JsonKey()
  List<AnnouncementEntity> get announcements {
    if (_announcements is EqualUnmodifiableListView) return _announcements;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_announcements);
  }

  /// Mensagem de erro, se houver
  @override
  final String? error;

  /// Indica se os dados foram carregados
  @override
  @JsonKey()
  final bool isLoaded;

  /// Filtro atual aplicado
  @override
  @JsonKey()
  final AnnouncementFilter filter;

  @override
  String toString() {
    return 'AnnouncementState(isLoading: $isLoading, announcements: $announcements, error: $error, isLoaded: $isLoaded, filter: $filter)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AnnouncementStateImpl &&
            (identical(other.isLoading, isLoading) ||
                other.isLoading == isLoading) &&
            const DeepCollectionEquality().equals(
              other._announcements,
              _announcements,
            ) &&
            (identical(other.error, error) || other.error == error) &&
            (identical(other.isLoaded, isLoaded) ||
                other.isLoaded == isLoaded) &&
            (identical(other.filter, filter) || other.filter == filter));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    isLoading,
    const DeepCollectionEquality().hash(_announcements),
    error,
    isLoaded,
    filter,
  );

  /// Create a copy of AnnouncementState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AnnouncementStateImplCopyWith<_$AnnouncementStateImpl> get copyWith =>
      __$$AnnouncementStateImplCopyWithImpl<_$AnnouncementStateImpl>(
        this,
        _$identity,
      );
}

abstract class _AnnouncementState implements AnnouncementState {
  const factory _AnnouncementState({
    final bool isLoading,
    final List<AnnouncementEntity> announcements,
    final String? error,
    final bool isLoaded,
    final AnnouncementFilter filter,
  }) = _$AnnouncementStateImpl;

  /// Indica se uma operação está em andamento
  @override
  bool get isLoading;

  /// Lista de anúncios
  @override
  List<AnnouncementEntity> get announcements;

  /// Mensagem de erro, se houver
  @override
  String? get error;

  /// Indica se os dados foram carregados
  @override
  bool get isLoaded;

  /// Filtro atual aplicado
  @override
  AnnouncementFilter get filter;

  /// Create a copy of AnnouncementState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AnnouncementStateImplCopyWith<_$AnnouncementStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
