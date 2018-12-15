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
 */
package com.percona.LinkBench;

import java.io.IOException;
import java.util.Properties;

import org.junit.experimental.categories.Category;

import com.facebook.LinkBench.DummyLinkStore;
import com.facebook.LinkBench.LinkStoreTestBase;
import com.facebook.LinkBench.Phase;
import com.mongodb.DB;
import com.percona.LinkBench.LinkStoreMongoDBv2;
import com.percona.LinkBench.testtypes.MongoDBTest;

/**
 * Test the MongoDB LinkStore implementation.
 *
 * Assumes that the database specified by the testDB field has been created
 * with permissions for a user to create collections, find,
 * insert, delete, etc.
 * 
 * @author dbennett - Adapted from MySQL unit test MySqlLinkStore 
 * 

 */
@Category(MongoDBTest.class)
public class MongoDBLinkStoreTest extends LinkStoreTestBase {

  private DB db=null;

  /** Properties for last initStore call */
  private Properties currProps;

  @Override
  protected long getIDCount() {
    // Make test smaller so that it doesn't take too long
    return 5000;
  }

  @Override
  protected int getRequestCount() {
    // Fewer requests to keep test quick
    return 10000;
  }

  protected Properties basicProps() {
    Properties props = super.basicProps();
    MongoDBTestConfig.fillMongoDBTestServerProps(props);
    return props;
  }


  @Override
  protected void initStore(Properties props) throws IOException, Exception {
    this.currProps = (Properties)props.clone();
    if (db != null)
      db.getMongo().close();
    db = MongoDBTestConfig.createConnection(testDB);
    MongoDBTestConfig.dropTestTables(db, testDB);
    MongoDBTestConfig.createTestTables(db, testDB);
  }

  @Override
  public DummyLinkStore getStoreHandle(boolean initialize) throws IOException, Exception {
    DummyLinkStore result = new DummyLinkStore(new LinkStoreMongoDBv2());
    if (initialize) {
      result.initialize(currProps, Phase.REQUEST, 0);
    }
    return result;
  }

  @Override protected void tearDown() throws Exception {
    super.tearDown();
    MongoDBTestConfig.dropTestTables(db, testDB);
    db.getMongo().close();
  }

}
