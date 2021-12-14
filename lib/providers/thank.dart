
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:qomalin_app/models/repositories/thank_repository.dart';

final _thankRepositoryProvider = Provider<ThankRepository>((ref) {
  return ThankRepositoryFirestoreImpl(ref.read);
});

class ThankProviders {
  const ThankProviders._();
  static Provider<ThankRepository> thankRepositoryProvider() {
    return _thankRepositoryProvider;
  }
}