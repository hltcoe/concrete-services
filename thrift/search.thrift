/*
 * Copyright 2016 Johns Hopkins University HLTCOE. All rights reserved.
 * This software is released under the 2-clause BSD license.
 * See LICENSE in the project root directory.
 */

namespace java edu.jhu.hlt.concrete.search
namespace py concrete.search
namespace cpp concrete.search

include "structure.thrift"
include "uuid.thrift"
include "metadata.thrift"

/**
 * Wrapper for information relevant to a (possibly structured) search.
 */
struct SearchQuery {
  /**
   * Individual words, or multiword phrases, e.g., 'dog', 'blue
   * cheese'.  It is the responsibility of the implementation of
   * Search* to tokenize multiword phrases, if so-desired.  Further,
   * an implementation may choose to support advanced features such as
   * wildcards, e.g.: 'blue *'.  This specification makes no
   * committment as to the internal structure of keywords and their
   * semantics: that is the responsibility of the individual
   * implementation.
   */
  1: optional list<string> keywords

  /**
   * e.g., "what is the capital of spain?"
   *
   * questions is a list in order that possibly different phrasings of
   * the question can be included, e.g.: "what is the name of spain's
   * capital?"
   */
  2: optional list<string> questions

  /**
   * Refers to an optional communication that can provide context for the query.
   */
  3: optional string communicationId

  /**
   * Refers to a sequence of tokens in the communication referenced by communicationId.
   */
  4: optional structure.TokenRefSequence tokens

  /** 
   * The input from the user provided in the search box, unmodified
   */
  5: optional string rawQuery

  /**
   * optional authorization mechanism
   */
  6: optional string auths
}

/**
 * An individual element returned from a search.  Most/all methods
 * will return a communicationId, possibly with an associated score.
 * For example if the target element type of the search is Sentence
 * then the sentenceId field should be populated.
 */
struct SearchResult {
  // e.g., nytimes_145
  1: optional string communicationId

  /** 
   * The UUID of the returned sentence, which appears in the
   * communication referenced by communicationId.
   */
  2: optional uuid.UUID sentenceId

  /**
   * Values are not restricted in range (e.g., do not have to be
   * within [0,1]).  Higher is better.
   *
   */
  3: optional double score
}

/**
 * Single wrapper for results from all the various Search* services.
 */
struct SearchResults {
  /**
   * The list is assumed sorted best to worst, which should be
   * reflected by the values contained in the score field of each
   * SearchResult, if that field is populated.
   */
  1: optional list<SearchResult> searchResults

  /**
   * The query that led to this result: likely use case for populating
   * this field is for building training data.  Presumably a
   * system will not need/want to return this object in live use.
   */
  2: optional SearchQuery searchQuery

  /**
   * The system that provided the response: likely use case for
   * populating this field is for building training data.  Presumably
   * a system will not need/want to return this object in live use.
   */
  3: optional metadata.AnnotationMetadata metadata
}

service Search {
  SearchResults searchCommunications(1: SearchQuery query)
  SearchResults searchSentences(1: SearchQuery query)
}
