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
 * each request or create a pool for reuse.
 *
 * TODO: move to services.thrift
 */
struct ThriftContactInfo {
  1: required string host
  2: required i32 port
}

/**
 * Annotation Tasks Types
 *
 * TODO: move to services.thrift or annotation.thrift
 */
enum AnnotationTaskType {
  TRANSLATION = 1
  NER = 2
}

/**
 * An annotation unit is the part of the communication to be annotated.
 */
enum AnnotationUnitType {
  COMMUNICATION = 1
  SENTENCE = 2
}

/**
 * An annotation unit is the part of the communication to be annotated.
 * It can be the entire communication or a particular sentence in the communication.
 * If the sentenceID is null, the unit is the entire communication
 */
struct AnnotationUnitIdentifier {
  /**
   * Communication identifier for loading data
   */
  1: required string communicationId

  /**
   * Sentence identifer if annotating sentences
   */
  2: optional uuid.UUID sentenceId
}

/**
 * Annotation task including information for pulling data.
 */
struct AnnotationTask {
  /**
   * Type of annotation task
   */
  1: required AnnotationTaskType type

  /**
   * Language of the data for the task
   */
  2: optional string language

  /**
   * Entire communication or individual sentences
   */
  3: required AnnotationUnitType unitType

  /**
   * Identifiers for each annotation unit
   */
  4: required list<AnnotationUnitIdentifier> units
}

/**
 * Annotation on a communication.
 */
struct Annotation {
  /**
   * Identifier of the part of the communication being annotated.
   */
  1: required AnnotationUnitIdentifier id

  /**
   * Communication with the annotation stored in it.
   * The location of the annotation depends on the annotation unit identifier
   */
  2: required communication.Communication communication
}

/**
 * The active learning server is responsible for sorting a list of communications.
 * Users annotate communications based on the sort.
 *
 * Active learning is an asynchronous process.
 * It is started by the client calling start().
 * At arbitrary times, the client can call addAnnotations().
 * When the server is done with a sort of the data, it calls submitSort() on the client.
 * The server can perform additional sorts until stop() is called.
 *
 * The server must be preconfigured with the details of the data source to pull communications.
 */
service ActiveLearnerServer {
  /**
   * Start an active learning session on these communications
   */
  bool start(1: uuid.UUID sessionId, 2: AnnotationTask task, 3: ThriftContactInfo contact)

  /**
   * Stop the learning session
   */
  void stop(1: uuid.UUID sessionId)

  /**
   * Add annotations from the user to the learning process
   */
  void addAnnotations(1: uuid.UUID sessionId, 2: list<Annotation> annotations)

  /**
   * Is the active learner server alive?
   */
  bool alive()
}

/**
 * The active learner client implements a single method to accept new sorts of the annotation units
 */
service ActiveLearnerClient {
  /**
   * Submit a new sort of communications to the broker
   */
  void submitSort(1: uuid.UUID sessionId, 2: list<AnnotationUnitIdentifier> unitIds)
}

