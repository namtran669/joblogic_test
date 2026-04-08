import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test_joblogic/features/sell/domain/entities/sell_item.dart';
import 'package:test_joblogic/features/sell/domain/usecases/sell_usecases.dart';

class MockSellRepository extends Mock implements SellRepository {}

void main() {
  late AddSellItemUseCase addSellItemUseCase;
  late MockSellRepository mockSellRepository;

  setUp(() {
    // Register Fallback Value
    registerFallbackValue(const SellItem(name: 't', price: 1, quantity: 1));

    mockSellRepository = MockSellRepository();
    addSellItemUseCase = AddSellItemUseCase(mockSellRepository);
  });

  const tSellItem = SellItem(id: 1, name: 'Phone', price: 500.0, quantity: 2);

  test('should call addItem on the repository properly', () async {
    // arrange
    when(() => mockSellRepository.addItem(any()))
        .thenAnswer((_) async => const Right(null));
    
    // act
    final result = await addSellItemUseCase(tSellItem);
    
    // assert
    expect(result, const Right(null));
    verify(() => mockSellRepository.addItem(tSellItem));
    verifyNoMoreInteractions(mockSellRepository);
  });
}
