/*
 * Copyright 2012, Facebook, Inc.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 * 
 * 
 * @author dbennett - Adapted from MySQL unit test MySqlNodeStore 
 * 
 */
package com.percona.LinkBench;

import java.io.IOException;
import java.util.Properties;

import org.junit.experimental.categories.Category;

import com.facebook.LinkBench.DummyLinkStore;
import com.facebook.LinkBench.NodeStore;
import com.facebook.LinkBench.NodeStoreTestBase;
import com.facebook.LinkBench.Phase;
import com.mongodb.DB;
import com.percona.LinkBench.LinkStoreMongoDBv2;
import com.percona.LinkBench.testtypes.MongoDBTest;

@Category(MongoDBTest.class)
public class MongoDBNodeStoreTest extends NodeStoreTestBase {

  DB db;
  Properties currProps;

  @Override
  protected Properties basicProps() {
    Properties props = super.basicProps();
    MongoDBTestConfig.fillMongoDBTestServerProps(props);
    return props;
  }

  @Override
  protected void initNodeStore(Properties props) throws Exception, IOException {
    currProps = props;
    db = MongoDBTestConfig.createConnection(testDB);
    MongoDBTestConfig.dropTestTables(db, testDB);
    MongoDBTestConfig.createTestTables(db, testDB);
  }

  @Override
  protected NodeStore getNodeStoreHandle(boolean initialize) throws Exception, IOException {
    DummyLinkStore result = new DummyLinkStore(new LinkStoreMongoDBv2());
    if (initialize) {
      result.initialize(currProps, Phase.REQUEST, 0);
    }
    return result;
  }

}
