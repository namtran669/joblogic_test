import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test_joblogic/features/call/domain/entities/call_entity.dart';
import 'package:test_joblogic/features/call/domain/repositories/call_repository.dart';
import 'package:test_joblogic/features/call/domain/usecases/get_calls_usecase.dart';

class MockCallRepository extends Mock implements CallRepository {}

void main() {
  late GetCallsUseCase usecase;
  late MockCallRepository mockCallRepository;

  setUp(() {
    mockCallRepository = MockCallRepository();
    usecase = GetCallsUseCase(mockCallRepository);
  });

  const tPaginatedInfo = CallPaginatedInfo(
    calls: [CallEntity(id: 1, name: 'Test User', phone: '12345')],
    hasMore: false,
  );

  test('should get call paginated info from the repository', () async {
    // arrange
    when(() => mockCallRepository.getCalls(any()))
        .thenAnswer((_) async => const Right(tPaginatedInfo));
    // act
    final result = await usecase(1);
    // assert
    expect(result, const Right(tPaginatedInfo));
    verify(() => mockCallRepository.getCalls(1));
    verifyNoMoreInteractions(mockCallRepository);
  });
}
