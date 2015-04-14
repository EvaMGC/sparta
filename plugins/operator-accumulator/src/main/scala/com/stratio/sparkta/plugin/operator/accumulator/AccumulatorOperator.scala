/**
 * Copyright (C) 2014 Stratio (http://stratio.com)
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *         http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
package com.stratio.sparkta.plugin.operator.accumulator

import java.io.{Serializable => JSerializable}
import com.stratio.sparkta.sdk._
import com.stratio.sparkta.sdk.ValidatingPropertyMap._

import scala.util.Try

class AccumulatorOperator(properties: Map[String, JSerializable]) extends Operator(properties) {

  private val inputField = if(properties.contains("inputField")) properties.getString("inputField") else ""

  override val key : String = inputField

  override val writeOperation = WriteOp.AccSet

  override def processMap(inputFields: Map[String, JSerializable]): Option[Any] =
    inputFields.contains(inputField) match {
      case false => AccumulatorOperator.SOME_EMPTY
      case true => Some(inputFields.get(inputField).get)
    }

  override def processReduce(values : Iterable[Option[Any]]): Option[String] = {
    Try(Some(values.map(_.get.toString).reduce(_ + AccumulatorOperator.SEPARATOR + _)))
      .getOrElse(AccumulatorOperator.SOME_EMPTY)
  }
}

private object AccumulatorOperator {
  val SOME_EMPTY = Some("")
  val SEPARATOR = " "
}

