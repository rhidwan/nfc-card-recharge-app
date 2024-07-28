import 'dart:typed_data';

import 'package:PureDrop/src/core/utils/extensions.dart';

Future<Uint8List> ntag2xxWritePage(int page, Uint8List data, tag) async {
  // TAG Type       PAGES   USER START    USER STOP
  // --------       -----   ----------    ---------
  // NTAG 203       42      4             39
  // NTAG 213       45      4             39
  // NTAG 215       135     4             129
  // NTAG 216       231     4             225

  if ((page < 4) || (page > 225)) {
    // Return Failed Signal
    return Uint8List.fromList([0]);
  }

  var cmd = Uint8List.fromList([0xA2, page, data[0], data[1], data[2], data[3]]);
  print(cmd.toHexString());
  var resp = await tag.transceive(data: cmd);
  return resp;
}


Future<Uint8List> ntag2xxWriteText(tag, String text) async {
  print("Started writing the code");
  List<int> pageBuffer = List.filled(4, 0);

  // Remove NDEF record overhead from the URI data (pageHeader below)
  int wrapperSize = 12;

  // Figure out how long the string is
  int len = text.length;
  print("writing data of length $len");

  // Make sure the URI payload will fit in dataLen (include 0xFE trailer)
  if (len < 1 || len + 1 > (250 - wrapperSize)) {
    print("Data size is larger, returning");
    return Uint8List(0);
  }

  // Setup the record header
  // See NFCForum-TS-Type-2-Tag_1.1.pdf for details
  Uint8List pageHeader = Uint8List.fromList([
    /* NDEF Lock Control TLV (must be first and always present) */
    0x01, // Tag Field (0x01 = Lock Control TLV)
    0x03, // Payload Length (always 3)
    0xA0, // The position inside the tag of the lock bytes (upper 4 = page address, lower 4 = byte offset)
    0x10, // Size in bits of the lock area
    0x44, // Size in bytes of a page and the number of bytes each lock bit can lock (4 bits + 4 bits)
    /* NDEF Message TLV - URI Record */
    0x03, // Tag Field (0x03 = NDEF Message)
    len + 5, // Payload Length (not including 0xFE trailer)
    0xD1, // NDEF Record Header (TNF=0x1:Well known record + SR + ME + MB)
    0x01, // Type Length for the record type indicator
    len + 1, // Payload len
    0x54, // Record Type Indicator (0x55 or 'U' = URI Record) 0x54 for Text
    0x02, // URI Prefix (ex. 0x01 = "http://www.")
  ]);

  var resp;
  // Write 12 byte header (three pages of data starting at page 4)
  pageBuffer.setAll(0, pageHeader.sublist(0, 4));

  resp = await ntag2xxWritePage(4, Uint8List.fromList(pageBuffer), tag);
  print(resp);
  // if (!ntag2xxWritePage(4, pageBuffer, tag)) {
  //   return Uint8List(0);
  // }
  pageBuffer.setAll(0, pageHeader.sublist(4, 8));
  // if (!ntag2xxWritePage(5, pageBuffer)) {
  //   return Uint8List(0);
  // }
  resp = await ntag2xxWritePage(5, Uint8List.fromList(pageBuffer), tag);
  print(resp);

  pageBuffer.setAll(0, pageHeader.sublist(8, 12));
  // if (!ntag2xxWritePage(6, pageBuffer)) {
  //   return Uint8List(0);
  // }
  resp = await ntag2xxWritePage(6, Uint8List.fromList(pageBuffer), tag);
  print(resp);

  // Write URI (starting at page 7)
  int currentPage = 7;
  String urlCopy = text;

  print("Got length ");
  while (len > 0) {
    if (len < 4) {
      pageBuffer.fillRange(0, 4, 0);
      pageBuffer.setAll(0, urlCopy.codeUnits);
      pageBuffer[len] = 0xFE; // NDEF record footer
      // if (!ntag2xxWritePage(currentPage, pageBuffer)) {
      //   return Uint8List(0);
      // }
      resp = await ntag2xxWritePage(currentPage, Uint8List.fromList(pageBuffer), tag);
      print(resp);

      // DONE!
      return Uint8List.fromList([1]);
    } else if (len == 4) {
      pageBuffer.setAll(0, urlCopy.codeUnits);
      // if (!ntag2xxWritePage(currentPage, pageBuffer)) {
      //   return Uint8List(0);
      // }
      resp = await ntag2xxWritePage(currentPage, Uint8List.fromList(pageBuffer), tag);
      print(resp);

      pageBuffer.fillRange(0, 4, 0);
      pageBuffer[0] = 0xFE; // NDEF record footer
      currentPage++;
      // if (!ntag2xxWritePage(currentPage, pageBuffer)) {
      //   return Uint8List(0);
      // }
      resp = await ntag2xxWritePage(currentPage, Uint8List.fromList(pageBuffer), tag);
      print(resp);
      // DONE!
      return Uint8List.fromList([1]);
    } else {
      // More than one page of data left
      pageBuffer.setAll(0, urlCopy.codeUnits.take(4).toList());
      // if (!ntag2xxWritePage(currentPage, pageBuffer)) {
      //   print("Failed to write on page $currentPage");
      //   return Uint8List(0);
      // }
      resp = await ntag2xxWritePage(currentPage, Uint8List.fromList(pageBuffer), tag);
      print(resp);

      currentPage++;
      urlCopy = urlCopy.substring(4);
      len -= 4;
    }
  }

  // Seems that everything was OK (?!)
  return Uint8List.fromList([1]);
}
