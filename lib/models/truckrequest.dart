class TruckRequest {
  String id;
  String from;
  String to;
  String reqDate;
  String startDate;
  String chassis;
  String model;
  String driverName;
  String km;
  String status;
  String comment;
  double startLong;
  double startLatt;
  double endLong;
  double endLatt;

  TruckRequest(
      {id,
      from,
      to,
      reqDate,
      startDate,
      chassis,
      model,
      km,
      status,
      comment,
      driverName,
      startLong,
      startLatt,
      endLong,
      endLatt}) {
    this.id = id;
    this.from = from ?? "N/A";
    this.to = to ?? "N/A";
    this.reqDate = reqDate ?? "N/A";
    this.driverName = driverName ?? "N/A";
    this.startDate = startDate ?? "N/A";
    this.chassis = chassis ?? "N/A";
    this.model = model ?? "N/A";
    this.km = km ?? "N/A";
    this.status = status ?? "N/A";
    this.comment = comment ?? "N/A";
    this.startLong = startLong;
    this.startLatt = startLatt;
    this.endLong = endLong;
    this.endLatt = endLatt;
  }

  TruckRequest.fromJson(Map<String, String> response) {
    this.id = response['TKRQ_ID'];
    this.from = response['TKRQ_STRT_LOC'] ?? "N/A";
    this.to = response['TKRQ_END_LOC'] ?? "N/A";
    this.reqDate = response['TKRQ_INSR_DATE'] ?? "N/A";
    this.startDate = response['TKRQ_STRT_DATE'] ?? "N/A";
    this.chassis = response['TKRQ_CHSS'] ?? "N/A";
    this.model = response['TRMD_NAME'] ?? "N/A";
    this.km = response['TKRQ_KM'] ?? "N/A";
    this.comment = response['TKRQ_CMNT'] ?? "N/A";
    this.driverName = response['DRVR_NAME'] ?? "N/A";
    this.status = response['TKRQ_STTS'] ?? "N/A";
    this.startLong = double.parse(response['TKRQ_STRT_LONG']) ?? 0;
    this.startLatt = double.parse(response['TKRQ_STRT_LATT']) ?? 0;
    this.endLong = double.parse(response['TKRQ_END_LONG']) ?? 0;
    this.endLatt = double.parse(response['TKRQ_END_LATT']) ?? 0;
  }
}
