/*
 * Copyright 2016 Johns Hopkins University HLTCOE. All rights reserved.
 * This software is released under the 2-clause BSD license.
 * See LICENSE in the project root directory.
 */

namespace java edu.jhu.hlt.concrete.services
namespace py concrete.services
namespace cpp concrete.services

/**
 * An exception to be used with Concrete services.
 */
exception ServicesException {
  /**
   * The explanation (why the exception occurred)
   */
  1: required string message

  /**
   * The serialized exception
   */
  2: optional binary serEx
}

