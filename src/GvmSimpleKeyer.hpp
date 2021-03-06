//
//  GvmSimpleKeyer.hpp
//  GvmCpp
//
//  Created by Mo DeJong on 8/14/15.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//

// Merges keys by choosing the non-null key of the more massive cluster when
// available. Where a key is being added to a cluster, any pre-existing key is
// preserved.

#import "GvmCommon.hpp"

namespace Gvm {
  // S
  //
  // Cluster vector space.
  
  // V
  //
  // Cluster vector type.
  
  // K
  //
  // Type of key.
  
  // FP
  //
  // Floating point type.
  
  template<typename S, typename V, typename K, typename FP>
  class GvmSimpleKeyer : public GvmKeyer<S,V,K,FP> {
  public:
    
    GvmSimpleKeyer<S,V,K,FP>()
    {
    }
    
    // Called when two clusters are being merged. One key needs to be
    // chosen/synthesized from those of the clusters being merged.
    //
    // c1 : the cluster with the greater mass
    // c2 : the cluster with the lesser mass
    // return a key for the cluster that combines those of c1 and c2, may be null
    
    K* mergeKeys(GvmCluster<S,V,K,FP> &c1, GvmCluster<S,V,K,FP> &c2)
    {
      K* k1 = c1.getKey();
      K* k2 = c2.getKey();
      if (k1 == nullptr) return k2;
      if (k2 == nullptr) return k1;
      return combineKeys(k1, k2);
    }
    
    // Called when a key is being added to a cluster.
    //
    // cluster
    // key : the key for a newly clustered coordinate
    // return the key to be assigned to the new cluster, may be null

    K* addKey(GvmCluster<S,V,K,FP> &cluster, K* k2)
    {
      K* k1 = cluster.getKey();
      if (k1 == nullptr) return k2;
      if (k2 == nullptr) return k1;
      return combineKeys(k1, k2);
    }
    
    // Combines two keys. Combining two keys may totally discard information
    // from one, both or none of the supplied keys.
    //
    // k1 : a key, not null
    // k2 : a key, not null
    // return a combined key
    
    virtual K* combineKeys(K* k1, K* k2) = 0;
    
  }; // end class GvmSimpleKeyer

}
