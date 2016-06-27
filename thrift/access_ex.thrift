/*
 * Copyright 2016 Johns Hopkins University HLTCOE. All rights reserved.
 * This software is released under the 2-clause BSD license.
 * See LICENSE in the project root directory.
 */

namespace java edu.jhu.hlt.concrete.access
namespace py concrete.access
namespace cpp concrete.access

/**
 * An exception to be used with Concrete send
 * services.
 */
exception SendException {
  /*
   * The explanation (why the exception occurred)
   */
  1: required string message

  /*
   * The serialized exception
   */
  2: optional binary serEx
}

/**
 * An exception to be used with Concrete retrieve
 * services.
 */
exception RetrieveException {
  /*
   * The explanation (why the exception occurred)
   */
  1: required string message

  /*
   * The serialized exception
   */
  2: optional binary serEx
}
