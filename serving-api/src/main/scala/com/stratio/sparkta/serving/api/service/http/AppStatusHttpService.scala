/**
 * Copyright (C) 2016 Stratio (http://stratio.com)
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

package com.stratio.sparkta.serving.api.service.http

import com.stratio.sparkta.serving.api.constants.HttpConstant
import com.stratio.sparkta.serving.core.CuratorFactoryHolder
import com.stratio.sparkta.serving.core.exception.ServingCoreException
import com.stratio.sparkta.serving.core.models.ErrorModel
import com.wordnik.swagger.annotations._
import org.apache.curator.framework.CuratorFramework
import spray.routing._

@Api(value = HttpConstant.AppStatus, description = "Operations about sparkta status.")
trait AppStatusHttpService extends BaseHttpService {

  override def routes: Route = checkStatus

  val curatorInstance : CuratorFramework

  @ApiOperation(value = "Finds all policy contexts",
    notes = "Returns a policies list",
    httpMethod = "GET",
    response = classOf[String],
    responseContainer = "List")
  @ApiResponses(
    Array(new ApiResponse(code = HttpConstant.NotFound,
      message = HttpConstant.NotFoundMessage)))
  def checkStatus: Route = {
    path(HttpConstant.AppStatus) {
      get {
        complete {
          if (!curatorInstance.getZookeeperClient.getZooKeeper.getState.isConnected)
            throw new ServingCoreException(ErrorModel.toString(
              new ErrorModel(ErrorModel.CodeUnknown, s"Zk isn't connected at" +
                s" ${curatorInstance.getZookeeperClient.getCurrentConnectionString}.")
            ))
          else "OK"
        }
      }
    }
  }
}
