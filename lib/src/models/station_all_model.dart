import 'dart:convert';

StationAllModel stationLocationModelFromJson(String str) =>
    StationAllModel.fromJson(json.decode(str));

String stationLocationModelToJson(StationAllModel data) =>
    json.encode(data.toJson());

class StationAllModel {
  StationAllModel({
    required this.id,
    required this.address,
    required this.batteryType,
    required this.battery,
    required this.confirmFunction,
    required this.resetMcu,
    required this.stationName,
    required this.statusBattery,
    required this.statusLocker,
    required this.statusStation,
    required this.latitude,
    required this.longitude,
    required this.stationId,
    required this.setting,
  });

  final String? id;
  final String? address;
  final String? batteryType;
  final List<Battery>? battery;
  final int? confirmFunction;
  final bool? resetMcu;
  final String? stationName;
  final bool? statusBattery;
  final bool? statusLocker;
  final bool? statusStation;
  final double? latitude;
  final double? longitude;
  final String? stationId;
  final Setting? setting;

  factory StationAllModel.fromJson(Map<String, dynamic> json) => StationAllModel(
    id: json["_id"] ?? '',
    address: json["address"] ?? '',
    batteryType: json["batteryType"] ?? '',
    battery: List<Battery>.from(json["battery"].map((x) => Battery.fromJson(x))),
    confirmFunction: json["confirmFunction"] ?? 0,
    resetMcu: json["resetMCU"] ?? false,
    stationName: json["stationName"] ?? '',
    statusBattery: json["statusBattery"] ?? false,
    statusLocker: json["statusLocker"] ?? false,
    statusStation: json["statusStation"] ?? false,
    latitude: json["latitude"] ?? 0.0,
    longitude: json["longitude"] ?? 0.0,
    stationId: json["stationId"] ?? '',
    setting: Setting.fromJson(json["setting"]),
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "address": address,
    "batteryType": batteryType,
    "battery": List<dynamic>.from(battery!.map((x) => x.toJson())),
    "confirmFunction": confirmFunction,
    "resetMCU": resetMcu,
    "stationName": stationName,
    "statusBattery": statusBattery,
    "statusLocker": statusLocker,
    "statusStation": statusStation,
    "latitude": latitude,
    "longitude": longitude,
    "stationId": stationId,
    "setting": setting!.toJson(),
  };
}

class Battery {
  Battery({
    required this.id,
    required this.name,
    required this.batteryId,
    required this.soc,
    required this.status,
    required this.voltage,
    required this.current,
    required this.timeStamp,
    required this.cutoffVoltage,
    required this.packVoltage,
    required this.packCurrent,
    required this.packSpace,
    required this.soh,
    required this.temperature,
    required this.minTemp,
    required this.maxTemp,
    required this.balancing,
    required this.packLocation,
    required this.upperVoltage,
    required this.lowerVoltage,
    required this.cellMax,
    required this.cellMin,
    required this.resCap,
    required this.cellAll,
    required this.alarmCode,
    required this.voltCells,
    required this.manualSwitch,
    required this.settingSlot,
    required this.isBooking,
    required this.userBooking,
    required this.timeBooking,
    required this.payment,
  });

  final dynamic id;
  final dynamic name;
  final dynamic batteryId;
  final dynamic soc;
  final dynamic status;
  final dynamic voltage;
  final dynamic current;
  final dynamic timeStamp;
  final dynamic cutoffVoltage;
  final dynamic packVoltage;
  final dynamic packCurrent;
  final dynamic packSpace;
  final dynamic soh;
  final dynamic temperature;
  final dynamic minTemp;
  final dynamic maxTemp;
  final dynamic balancing;
  final dynamic packLocation;
  final dynamic upperVoltage;
  final dynamic lowerVoltage;
  final dynamic cellMax;
  final dynamic cellMin;
  final dynamic resCap;
  final dynamic cellAll;
  final dynamic alarmCode;
  final Map<String, double> voltCells;
  final dynamic manualSwitch;
  final dynamic settingSlot;
  final dynamic isBooking;
  final dynamic userBooking;
  final dynamic timeBooking;
  final dynamic payment;

  factory Battery.fromJson(Map<String, dynamic> json) => Battery(
        id: json["id"],
        name: json["name"],
        batteryId: json["battery_id"],
        soc: json["SOC"],
        status: json["status"],
        voltage: json["voltage"],
        current: json["current"],
        timeStamp: json["time_stamp"],
        cutoffVoltage: json["cutoff_voltage"],
        packVoltage: json["pack_voltage"],
        packCurrent: json["pack_current"],
        packSpace: json["pack_space"],
        soh: json["SOH"],
        temperature: json["temperature"],
        minTemp: json["min_temp"],
        maxTemp: json["max_temp"],
        balancing: json["balancing"],
        packLocation: json["pack_location"],
        upperVoltage: json["upper_voltage"],
        lowerVoltage: json["lower_voltage"],
        cellMax: json["cell_max"],
        cellMin: json["cell_min"],
        resCap: json["res_cap"],
        cellAll: json["cell_all"],
        alarmCode: json["alarm_code"],
        voltCells: Map.from(json["volt_cells"])
            .map((k, v) => MapEntry<String, double>(k, v.toDouble())),
        manualSwitch: json["manualSwitch"],
        settingSlot: json["settingSlot"],
        isBooking: json["isBooking"],
        userBooking: json["userBooking"],
        timeBooking: json["timeBooking"],
        payment: json["payment"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "battery_id": batteryId,
        "SOC": soc,
        "status": status,
        "voltage": voltage,
        "current": current,
        "time_stamp": timeStamp,
        "cutoff_voltage": cutoffVoltage,
        "pack_voltage": packVoltage,
        "pack_current": packCurrent,
        "pack_space": packSpace,
        "SOH": soh,
        "temperature": temperature,
        "min_temp": minTemp,
        "max_temp": maxTemp,
        "balancing": balancing,
        "pack_location": packLocation,
        "upper_voltage": upperVoltage,
        "lower_voltage": lowerVoltage,
        "cell_max": cellMax,
        "cell_min": cellMin,
        "res_cap": resCap,
        "cell_all": cellAll,
        "alarm_code": alarmCode,
        "volt_cells":
            Map.from(voltCells).map((k, v) => MapEntry<String, dynamic>(k, v)),
        "manualSwitch": manualSwitch,
        "settingSlot": settingSlot,
        "isBooking": isBooking,
        "userBooking": userBooking,
        "timeBooking": timeBooking,
        "payment": payment,
      };
}

class Setting {
  Setting({
    required this.price,
  });

  final int price;

  factory Setting.fromJson(Map<String, dynamic> json) => Setting(
    price: json["price"],
  );

  Map<String, dynamic> toJson() => {
    "price": price,
  };
}
