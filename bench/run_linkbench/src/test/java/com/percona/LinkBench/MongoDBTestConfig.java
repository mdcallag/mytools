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

import java.net.UnknownHostException;
import java.util.LinkedHashMap;
import java.util.Properties;

import com.facebook.LinkBench.Config;
import com.mongodb.BasicDBObject;
import com.mongodb.DB;
import com.mongodb.DBCollection;
import com.mongodb.MongoClient;
import com.mongodb.MongoClientException;
import com.mongodb.MongoClientURI;
import com.percona.LinkBench.LinkStoreMongoDBv2;

/**
 * Class containing hardcoded parameters and helper functions used to create
 * and connect to the unit test database for MongoDB 
 * 
 * @author tarmstrong (original MySQL version)
 * @author dbennett (Adapted for MongoDB)
 */
public class MongoDBTestConfig {

  // Hardcoded parameters for now
  static String host = "localhost";
  static int port = 27017;
  static String user = "";
  static String pass = "";
  static String linktable = "test_link";
  static String counttable = "test_count";
  static String nodetable = "test_node";
  static String transtable = "test_transaction";

  public static void fillMongoDBTestServerProps(Properties props) {
    props.setProperty(Config.LINKSTORE_CLASS, LinkStoreMongoDBv2.class.getName());
    props.setProperty(Config.NODESTORE_CLASS, LinkStoreMongoDBv2.class.getName());
    props.setProperty(LinkStoreMongoDBv2.CONFIG_HOST, host);
    props.setProperty(LinkStoreMongoDBv2.CONFIG_PORT, Integer.toString(port));
    props.setProperty(LinkStoreMongoDBv2.CONFIG_USER, user);
    props.setProperty(LinkStoreMongoDBv2.CONFIG_PASSWORD, pass);
    props.setProperty(Config.LINK_TABLE, linktable);
    props.setProperty(Config.COUNT_TABLE, counttable);
    props.setProperty(Config.NODE_TABLE, nodetable);
    props.setProperty(Config.TRANS_TABLE, transtable);
  }

  static DB createConnection(String testDB)
     throws InstantiationException,
      IllegalAccessException, ClassNotFoundException, MongoClientException,
      UnknownHostException {
    
    StringBuilder mongoUri = new StringBuilder("mongodb://");
    if (user != null && !"".equals(user.trim())
        && pass != null && !"".equals(pass.trim())) {
      mongoUri.append(user+":"+pass+"@");
    }
    if (host != null && !"".equals(host.trim()))
      mongoUri.append(host);
    if (port > 0)
      mongoUri.append(":"+port);
    mongoUri.append("/");
    if (testDB != null && !"".equals(testDB.trim()))
      mongoUri.append(testDB);
    
    MongoClient mongoClient = new MongoClient(
        new MongoClientURI( mongoUri.toString() )
    );
    
    return(mongoClient.getDB( testDB ));

  }

  @SuppressWarnings("serial")
  static void createTestTables(DB db, String testDB)
                                          throws MongoClientException {

    
    // get handles to the collections
    DBCollection linkColl = getOrCreateCollection(db, linktable);
    DBCollection nodeColl = getOrCreateCollection(db, nodetable);
    DBCollection countColl = getOrCreateCollection(db, counttable);
    DBCollection transColl = getOrCreateCollection(db, transtable);
    
    // create indexes
    linkColl.createIndex(
        new BasicDBObject(new LinkedHashMap<String,Object>(){{
          put("link_type",new Integer("1"));
          put("id1",new Integer("1"));
          put("id2",new Integer("1"));
        }}),
        new BasicDBObject("unique",true)
    );
    linkColl.createIndex(
        new BasicDBObject(new LinkedHashMap<String,Object>(){{
          put("id1",new Integer("1"));
          put("link_type",new Integer("1"));
          put("visibility",new Integer("1"));
          put("time",new Integer("1"));
          put("id2",new Integer("1"));
          put("version",new Integer("1"));
          put("data",new Integer("1"));
        }}),
        new BasicDBObject("unique",true)
    );
    countColl.createIndex(
        new BasicDBObject(new LinkedHashMap<String,Object>(){{
          put("id",new Integer("1"));
          put("link_type",new Integer("1"));
        }}),
        new BasicDBObject("unique",true)
    );
    nodeColl.createIndex(
        new BasicDBObject(new LinkedHashMap<String,Object>(){{
          put("id",new Integer("1"));
        }}),
        new BasicDBObject("unique",true)
    );
    transColl.createIndex(
        new BasicDBObject(new LinkedHashMap<String,Object>(){{
          put("link_type",new Integer("1"));
          put("id1",new Integer("1"));
          put("id2",new Integer("1"));
        }})
    );    

  }

  static void dropTestTables(DB db, String testDB)
                                                    throws MongoClientException {
    // get handles to the collections
    DBCollection linkColl = getOrCreateCollection(db, linktable);
    DBCollection nodeColl = getOrCreateCollection(db, nodetable);
    DBCollection countColl = getOrCreateCollection(db, counttable);
    DBCollection transColl = getOrCreateCollection(db, transtable);

    linkColl.drop();
    nodeColl.drop();
    countColl.drop();
    transColl.drop();
    
  }

  private static DBCollection getOrCreateCollection(DB db, String collectionName) {
    boolean collectionExists = db.collectionExists(collectionName);
    if (collectionExists == false) {
        db.createCollection(collectionName, null);
    }
    return(db.getCollection(collectionName));
  }

}
