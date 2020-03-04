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

  TruckRequest({id, from, to, reqDate, startDate, chassis, model, km, status, comment, driverName}) {
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
  }
}
