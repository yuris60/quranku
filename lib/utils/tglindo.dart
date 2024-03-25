import 'package:intl/intl.dart';

String formatTglIndo(String tanggal) {
  DateTime dateTime = DateFormat("yyyy-MM-dd").parse(tanggal);

  var M = DateFormat('MM').format(dateTime);
  var d = DateFormat('dd').format(dateTime).toString();
  var Y = DateFormat('yyyy').format(dateTime).toString();

  // hari
  var day = DateFormat('EEEE').format(dateTime);
  var hari = "";
  switch (day) {
    case 'Sunday':
      {
        hari = "Minggu";
      }
      break;
    case 'Monday':
      {
        hari = "Senin";
      }
      break;
    case 'Tuesday':
      {
        hari = "Selasa";
      }
      break;
    case 'Wednesday':
      {
        hari = "Rabu";
      }
      break;
    case 'Thursday':
      {
        hari = "Kamis";
      }
      break;
    case 'Friday':
      {
        hari = "Jumat";
      }
      break;
    case 'Saturday':
      {
        hari = "Sabtu";
      }
      break;
    }

  //bulan
  var month = "";
  switch (M) {
    case '01':
      {
        month = "Januari";
      }
      break;
    case '02':
      {
        month = "Februari";
      }
      break;
    case '03':
      {
        month = "Maret";
      }
      break;
    case '04':
      {
        month = "April";
      }
      break;
    case '05':
      {
        month = "Mei";
      }
      break;
    case '06':
      {
        month = "Juni";
      }
      break;
    case '07':
      {
        month = "Juli";
      }
      break;
    case '08':
      {
        month = "Agustus";
      }
      break;
    case '09':
      {
        month = "September";
      }
      break;
    case '10':
      {
        month = "Oktober";
      }
      break;
    case '11':
      {
        month = "November";
      }
      break;
    case '12':
      {
        month = "Desember";
      }
      break;
  }
  return "$hari, $d $month $Y";
}