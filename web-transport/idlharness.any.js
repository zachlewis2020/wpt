// META: global=window,worker
// META: script=/resources/WebIDLParser.js
// META: script=/resources/idlharness.js

'use strict';

idl_test(
  ['web-transport'],
  [],
  idl_array => {
    idl_array.add_objects({
      QuicTransport: ['new QuicTransport("quic-transport://example.com")'],
      Http3Transport: ['new Http3Transport("https://example.com")'],
      // TODO: The stream APIs below require a working connection to create.
      // BidirectionalStream
      // SendStream
      // ReceiveStream
    });
  }
);
