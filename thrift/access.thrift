/*
 * Copyright 2016 Johns Hopkins University HLTCOE. All rights reserved.
 * This software is released under the 2-clause BSD license.
 * See LICENSE in the project root directory.
 */

namespace java edu.jhu.hlt.concrete.access
namespace py concrete.access
namespace cpp concrete.access

include "communications.thrift"

/**
 * Struct representing results from the Retriever service.
 */
struct RetrieveResults {
  /**
   * a list of Communication objects that represent the results of the request
   */
  1: required list<communication.Communication> communications
}

/**
 * Struct representing a request from Retriever service.
 */
struct RetrieveRequest {
  /**
   * a list of Communication IDs
   */
  1. required list<string> communicationIds
  /**
   * optional authentication mechanism
   */
  2. optional string auths
}

/**
 * Service to retrieve particular communications.
 */ 
service Retriever {
  1. RetrieveResults retrieve(1: RetrieveRequest request)
}

/**
 * A service that exists so that clients can send Concrete data
 * structures to implementing servers.
 *
 * Implement this if you are creating an analytic that wishes to
 * send its results back to a server. That server may perform
 * validation, write the new layers to a database, and so forth.
 */
service Sender {
  /**
   * Send a communication to a server implementing this method.
   *
   * The communication that is sent back should contain the new
   * analytic layers you wish to append. You may also wish to call
   * methods that unset annotations you feel the receiver would not
   * find useful in order to reduce network overhead.
   */
  oneway void send(1: communication.Communication communication)
}
