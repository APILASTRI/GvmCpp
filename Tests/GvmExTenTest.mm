//
//  GvmExTenTest.mm
//  GvmTest
//
//  Created by Mo DeJong on 8/4/15.
//  Copyright (c) 2015 helpurock. All rights reserved.
//
//  Clustering test example with 10 points, a simple 2D scatter plot shows 3 primary
//  clusters all along a correlated line.

#import <Cocoa/Cocoa.h>
#import <XCTest/XCTest.h>

#import "Gvm.hpp"

#include <iostream>

using namespace std;
using namespace Gvm;

@interface GvmExTenTest : XCTestCase

@end

@implementation GvmExTenTest

- (vector<vector<double> >) getTestTenSampleVec
{
  double data2D[] = {
  0.3325312236041255,0.48738482998727056,
  0.34623985334890334,0.5347660877788399,
  0.2748244527993096,0.3467986203074948,
  0.7136742195009704,0.36177938722906483,
  0.6318292800942289,0.729730195802691,
  0.3470855716936217,0.552559573732038,
  0.3623743087637443,0.5248033439746583,
  0.6111643061119941,0.7422235950519993,
  0.31218064389129385,0.533100359437152,
  0.6533443188801747,0.7457430915431426
  };
  
  vector<vector<double> > coordsVec;
  
  for (int i = 0; i < sizeof(data2D)/sizeof(double); i+= 2) {
    double x = data2D[i];
    double y = data2D[i+1];
    
    vector<double> coords;
    coords.push_back(x);
    coords.push_back(y);
    
    coordsVec.push_back(coords);
  }
  
  assert(coordsVec.size() == 10);
  
  return coordsVec;
}

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testGvmTen {

  // The cluster "key" is a list of int values that correspond
  // to a certain coordinate.
  
# define ClusterKey vector<vector<double> >
  
  GvmVectorSpace<double> vspace(2);
  
  GvmClusters<GvmVectorSpace<double>, ClusterKey, double> clusters(vspace, 3);
  
  vector<vector<double> > listOfPoints = [self getTestTenSampleVec];
  
  for ( vector<double> & pt : listOfPoints ) {
    clusters.add(1, pt, nullptr);
  }
  
  // 3 clusters
  
  vector<GvmResult<GvmVectorSpace<double>, ClusterKey, double>> results = clusters.results();
  
  XCTAssert(results.size() == 3);
  
  /*
   Java results with no initial rand() on input order:
   
   cluster 0 contains 6 points
   cluster result: [0.329206009016833, 0.49656880253624225]  count: 6  variance: 0.034  mass: 6.000  key: [[D@2503dbd3, [D@4b67cf4d, [D@7ea987ac, [D@12a3a380, [D@29453f44, [D@5cad8086]
   cluster 1 contains 1 points
   cluster result: [0.7136742195009704, 0.36177938722906483]  count: 1  variance: 0.000  mass: 1.000  key: [[D@6e0be858]
   cluster 2 contains 3 points
   cluster result: [0.6321126350287992, 0.7392322941326109]  count: 3  variance: 0.001  mass: 3.000  key: [[D@61bbe9ba, [D@610455d6, [D@511d50c0]
   wrote 10 total pixels
   cluster 0
   0.333 0.487
   0.346 0.535
   0.275 0.347
   0.347 0.553
   0.362 0.525
   0.312 0.533
   cluster 1
   0.714 0.362
   cluster 2
   0.632 0.730
   0.611 0.742
   0.653 0.746
   
   */
  
  if (false) {
  for ( auto & result : results ) {
    cout << "cluster: " << result.toString() << endl;
  }
  }
  
  auto & result0 = results[0];
  auto & result1 = results[1];
  auto & result2 = results[2];
  
  double cx, cy;
  
  // cluster 0: count 6, mass 6
  
  XCTAssert(result0.count == 6);
  XCTAssert(result0.mass == 6);
  
  // cluster center of mass
  // [0.329206009016833, 0.49656880253624225]
  cx = result0.point[0];
  cy = result0.point[1];
  XCTAssert(int(round(cx * 100.0)) == 33);
  XCTAssert(int(round(cy * 100.0)) == 50);
  
  // cluster 1: count 1, mass 1
  
  XCTAssert(result1.count == 1);
  XCTAssert(result1.mass == 1);
  
  // cluster center of mass
  // [0.7136742195009704, 0.36177938722906483]
  cx = result1.point[0];
  cy = result1.point[1];
  XCTAssert(int(round(cx * 100.0)) == 71);
  XCTAssert(int(round(cy * 100.0)) == 36);
  
  // cluster 2: count 3, mass 3
  
  XCTAssert(result2.count == 3);
  XCTAssert(result2.mass == 3);
  
  // cluster center of mass
  // [0.6321126350287992, 0.7392322941326109]
  cx = result2.point[0];
  cy = result2.point[1];
  XCTAssert(int(round(cx * 100.0)) == 63);
  XCTAssert(int(round(cy * 100.0)) == 74);
  
  // FIXME: cluster variance does not seem to match
  
# undef ClusterKey
}

@end
