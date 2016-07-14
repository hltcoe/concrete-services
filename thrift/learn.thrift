/*
 * Copyright 2016 Johns Hopkins University HLTCOE. All rights reserved.
 * This software is released under the 2-clause BSD license.
 * See LICENSE in the project root directory.
 */

namespace java edu.jhu.hlt.concrete.learn
namespace py concrete.learn

include "uuid.thrift"
include "communication.thrift"

/**
 * Contact information for the broker.
 * The active learner does not need to know about the broker because it provides
 * its contact information on each request. It can create a thrift client for
 * each request or create a pool for resuse.
 */
struct BrokerContactInfo {
  1: required string host
  2: required i32 port
}

/**
 * The active learning server is responsible for sorting a list of communications.
 * Users annotate communications based on the sort.
 *
 * Active learning is an asynchronous process.
 * It is started by the client calling startLearning().
 * At arbitrary times, the client can call addAnnotations().
 * When the server is done with a sort of the data, it calls submitSort() on the client.
 * The server can perform additional sorts until stopLearning() is called.
 *
 * The server must be preconfigured with the details of the data source to pull communications.
 */
service ActiveLearnerServer {
  /**
   * Start an active learning session of these communications
   */
  void startLearning(1: uuid.UUID sessionId, 2: list<string> communicationIds, 3: BrokerContactInfo contact)

  /**
   * Stop the learning session
   */
  void stopLearning(1: uuid.UUID sessionId)

  /**
   * Add annotations from the user to the learning process
   */
  void addAnnotations(1: uuid.UUID sessionId, 2: list<communication.Communication> communications)

  /**
   * Is the active learner server alive?
   */
  bool alive()
}

/**
 * The active learner client implements a single method to accept new sorts of the communications
 */
service ActiveLearnerClient {
  /**
   * Submit a new sort of communications to the broker
   */
  void submitSort(1: uuid.UUID sessionId, 2: list<string> communicationIds)
}

