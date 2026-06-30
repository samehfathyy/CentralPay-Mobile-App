
import 'package:android_sms_reader/android_sms_reader.dart';
import 'package:budgeta/business%20features/select%20sms%20provider/data/sms_provider.dart';
import 'package:budgeta/core/database/dbHelper.dart';
import 'package:permission_handler/permission_handler.dart';

class SmsProvidersRepo {
  final DBHelper _dbHelper;

  SmsProvidersRepo({required DBHelper dbHelper}) : _dbHelper = dbHelper;
  List<SmsProvider> _selectedProviders = [];
  List<SmsProvider> _notSelectedProviders = [];

  Future<void> _loadSelectedProviders() async {
    _selectedProviders = await _dbHelper.getSmsProviders();
  }

  Future<List<SmsProvider>> _getAllSmsProvidersFromPhone() async {
    int offset = 0;
    Set<String> smsProviders = {};
    while (true) {
      final messages = await AndroidSMSReader.fetchMessages(
        type: AndroidSMSType.inbox,
        start: offset,
        count: 1000,
      );
      if (messages.isEmpty) break;

      for (var msg in messages) {
        smsProviders.add(msg.address);
      }
      offset += messages.length;
    }
    final smsProvidersList = smsProviders.toList();
    List<SmsProvider> filteredList = [];
    for (String item in smsProvidersList) {
      //check for phone numbers
      if (RegExp(r'\d').allMatches(item).length > 4) {
        continue;
      }
      if (item.isEmpty) continue;

      filteredList.add(SmsProvider(id: 0, name: item, selected: false));
    }
    return filteredList;
  }

  List<SmsProvider> getSelected() {
    return _selectedProviders;
  }

  List<SmsProvider> getNotSelected() {
    return _notSelectedProviders;
  }

  Future<void> loadSelectedAndNonSelectedProviders() async {
    var status = await Permission.sms.status;
    if (!status.isGranted) {
      return;
    }
    _selectedProviders.clear();
    _notSelectedProviders.clear();
    await _loadSelectedProviders();
    final allProviders = await _getAllSmsProvidersFromPhone();
    // List<String> toBeRemoved = [];
    for (var selectedProvider in _selectedProviders) {
      allProviders.removeWhere((element) {
        return element.name == selectedProvider.name;
      });
    }
    _notSelectedProviders = List.of(allProviders);
  }

  void swap(dynamic p) {
    if (_selectedProviders.contains(p)) {
      print("in selected list");
      _selectedProviders.remove(p);
      _notSelectedProviders.add(p);
      return;
    }
    if (_notSelectedProviders.contains(p)) {
      print("in not selected list");
      _notSelectedProviders.remove(p);
      _selectedProviders.add(p);
    }
  }

  Future<void> saveSelectingProcess() async {
    List<SmsProvider> providersToBeAdded = [];
    List<SmsProvider> providersToRemoved = [];
    for (SmsProvider item in _selectedProviders) {
      if (!item.selected) {
        providersToBeAdded.add(item);
      }
    }
    for (SmsProvider item in _notSelectedProviders) {
      if (item.selected) {
        providersToRemoved.add(item);
      }
    }
    if (providersToBeAdded.isNotEmpty) {
      await _dbHelper.insertSMSProviders(providersToBeAdded);
    }
    if (providersToRemoved.isNotEmpty) {
      await _dbHelper.removeSmsProviders(providersToRemoved);
    }
  }
}
