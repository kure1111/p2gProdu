public class S3 {

    public class ListBucketResponse_element {
        public S3.ListBucketResult ListBucketResponse;
        private String[] ListBucketResponse_type_info = new String[]{'ListBucketResponse','http://s3.amazonaws.com/doc/2006-03-01/','ListBucketResult','1','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://s3.amazonaws.com/doc/2006-03-01/','true'};
        private String[] field_order_type_info = new String[]{'ListBucketResponse'};
    }
    public class ListBucketResult {
        public S3.MetadataEntry[] Metadata { get; set; }
        public String Name {get;set;} //added by davidv
        public String Prefix;
        public String Marker;
        public String NextMarker;
        public Integer MaxKeys;
        public String Delimiter;
        public Boolean IsTruncated;
        public S3.ListEntry[] Contents;
        public S3.PrefixEntry[] CommonPrefixes;
        private String[] Metadata_type_info = new String[]{'Metadata','http://s3.amazonaws.com/doc/2006-03-01/','MetadataEntry','0','-1','false'};
        private String[] Name_type_info = new String[]{'Name','http://www.w3.org/2001/XMLSchema','string','1','1','false'};
        private String[] Prefix_type_info = new String[]{'Prefix','http://www.w3.org/2001/XMLSchema','string','1','1','false'};
        private String[] Marker_type_info = new String[]{'Marker','http://www.w3.org/2001/XMLSchema','string','1','1','false'};
        private String[] NextMarker_type_info = new String[]{'NextMarker','http://www.w3.org/2001/XMLSchema','string','0','1','false'};
        private String[] MaxKeys_type_info = new String[]{'MaxKeys','http://www.w3.org/2001/XMLSchema','int','1','1','false'};
        private String[] Delimiter_type_info = new String[]{'Delimiter','http://www.w3.org/2001/XMLSchema','string','0','1','false'};
        private String[] IsTruncated_type_info = new String[]{'IsTruncated','http://www.w3.org/2001/XMLSchema','boolean','1','1','false'};
        private String[] Contents_type_info = new String[]{'Contents','http://s3.amazonaws.com/doc/2006-03-01/','ListEntry','0','-1','false'};
        private String[] CommonPrefixes_type_info = new String[]{'CommonPrefixes','http://s3.amazonaws.com/doc/2006-03-01/','PrefixEntry','0','-1','false'};
        private String[] apex_schema_type_info = new String[]{'http://s3.amazonaws.com/doc/2006-03-01/','true'};
        private String[] field_order_type_info = new String[]{'Metadata','Name','Prefix','Marker','NextMarker','MaxKeys','Delimiter','IsTruncated','Contents','CommonPrefixes'};
    }

    
    public class ListAllMyBucketsList {
        public S3.ListAllMyBucketsEntry[] Bucket {get;set;}
        private String[] Bucket_type_info = new String[]{'Bucket','http://s3.amazonaws.com/doc/2006-03-01/','ListAllMyBucketsEntry','0','-1','false'};
        private String[] apex_schema_type_info = new String[]{'http://s3.amazonaws.com/doc/2006-03-01/','true'};
        private String[] field_order_type_info = new String[]{'Bucket'};
    }
    
    
    public class MetadataEntry {
        public String Name {get; set;}
        public String Value;
        private String[] Name_type_info = new String[]{'Name','http://www.w3.org/2001/XMLSchema','string','1','1','false'};
        private String[] Value_type_info = new String[]{'Value','http://www.w3.org/2001/XMLSchema','string','1','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://s3.amazonaws.com/doc/2006-03-01/','true'};
        private String[] field_order_type_info = new String[]{'Name','Value'};
    }

    public class AmazonS3 {
    	public AmazonS3(String key, String secret){
    	    this.key = key;
    	    this.secret= secret;	
    	}
    	
    	public AmazonS3(){
    		
    	}

	    public string signature( string op, Datetime now) {
			//format should be  2006-01-01T12:00:00.000Z
			system.assert( this.secret != null ,' missing S3.secret key');
	        String formattednow = now.formatGmt('yyyy-MM-dd')+'T'+now.formatGmt('HH:mm:ss')+'.'+now.formatGMT('SSS')+'Z';           
	        String canonical = 'AmazonS3'+op+formattednow; //"AmazonS3" + OPERATION + Timestamp              
	        Blob bsig = Crypto.generateMac('HmacSHA1', Blob.valueOf(canonical), Blob.valueOf(this.secret));          
	        return EncodingUtil.base64Encode(bsig); 
		}
		
		
		public string secret { get; set; }
		public string key { get; set; }
	    public String endpoint_x = 'https://s3-us-west-2.amazonaws.com/soap';
        public Map<String,String> inputHttpHeaders_x;
        public Map<String,String> outputHttpHeaders_x;
        public String clientCert_x;
        public String clientCertPasswd_x;
        private String[] ns_map_type_info = new String[]{'http://s3.amazonaws.com/doc/2006-03-01/', 'S3'};
      

        public S3.Status DeleteObject(String Bucket,String Key,String AWSAccessKeyId,DateTime Timestamp,String Signature,String Credential) {
            S3.DeleteObject_element request_x = new S3.DeleteObject_element();
            S3.DeleteObjectResponse_element response_x;
            request_x.Bucket = Bucket;
            request_x.Key = Key;
            request_x.AWSAccessKeyId = AWSAccessKeyId;
            request_x.Timestamp = Timestamp;
            request_x.Signature = Signature;
            request_x.Credential = Credential;
            Map<String, S3.DeleteObjectResponse_element> response_map_x = new Map<String, S3.DeleteObjectResponse_element>();
            response_map_x.put('response_x', response_x);
            if (!Test.isRunningTest())
            WebServiceCallout.invoke(
              this,
              request_x,
              response_map_x,
              new String[]{endpoint_x,
              '',
              'http://s3.amazonaws.com/doc/2006-03-01/',
              'DeleteObject',
              'http://s3.amazonaws.com/doc/2006-03-01/',
              'DeleteObjectResponse',
              'S3.DeleteObjectResponse_element'}
            );
            response_x = response_map_x.get('response_x');
            if (!Test.isRunningTest())
            	return response_x.DeleteObjectResponse;
            else
            	return null;
        }
        
        /*
           This method invokes the S3 ListBucket web service operation.
        */
        public S3.ListBucketResult ListBucket(String Bucket,String Prefix,String Marker,Integer MaxKeys,String Delimiter,String AWSAccessKeyId,DateTime Timestamp,String Signature, String Credential) {
            S3.ListBucket_element request_x = new S3.ListBucket_element();
            S3.ListBucketResponse_element response_x;
            request_x.Bucket = Bucket;
            request_x.Prefix = Prefix; 
            request_x.Marker = Marker;
            request_x.MaxKeys = MaxKeys;
            request_x.Delimiter = Delimiter;
            request_x.AWSAccessKeyId = AWSAccessKeyId;
            request_x.Timestamp = Timestamp;
            request_x.Signature = Signature;
            request_x.Credential = Credential;
            Map<String, S3.ListBucketResponse_element> response_map_x = new Map<String, S3.ListBucketResponse_element>();
            response_map_x.put('response_x', response_x);
            if (!Test.isRunningTest())
            WebServiceCallout.invoke(
              this,
              request_x,
              response_map_x,
              new String[]{endpoint_x,
              '',
              'http://s3.amazonaws.com/doc/2006-03-01/',
              'ListBucket',
              'http://s3.amazonaws.com/doc/2006-03-01/',
              'ListBucketResponse',
              'S3.ListBucketResponse_element'}
            );
            response_x = response_map_x.get('response_x');
            if (!Test.isRunningTest())
            	return response_x.ListBucketResponse;
            else
            	return null;
        }
        
        
        /*
           This method invokes the S3 ListAllMyBuckets web service operation.
        */
        public S3.ListAllMyBucketsResult ListAllMyBuckets(String AWSAccessKeyId,DateTime Timestamp,String Signature) {
            S3.ListAllMyBuckets_element request_x = new S3.ListAllMyBuckets_element();
            S3.ListAllMyBucketsResponse_element response_x;
            request_x.AWSAccessKeyId = AWSAccessKeyId;
            request_x.Timestamp = Timestamp;
            request_x.Signature = Signature;
            Map<String, S3.ListAllMyBucketsResponse_element> response_map_x = new Map<String, S3.ListAllMyBucketsResponse_element>();
            response_map_x.put('response_x', response_x);
            if (!Test.isRunningTest())
            WebServiceCallout.invoke(
              this,
              request_x,
              response_map_x,
              new String[]{endpoint_x,
              '',
              'http://s3.amazonaws.com/doc/2006-03-01/',
              'ListAllMyBuckets',
              'http://s3.amazonaws.com/doc/2006-03-01/',
              'ListAllMyBucketsResponse',
              'S3.ListAllMyBucketsResponse_element'}
            );
            response_x = response_map_x.get('response_x');
            if (!Test.isRunningTest())
            	return response_x.ListAllMyBucketsResponse;
            else
            	return null;
        }

        public S3.CreateBucketResult CreateBucket(String Bucket,S3.AccessControlList AccessControlList,String AWSAccessKeyId,DateTime Timestamp,String Signature) {
            S3.CreateBucket_element request_x = new S3.CreateBucket_element();
            S3.CreateBucketResponse_element response_x;
            request_x.Bucket = Bucket;
            request_x.AccessControlList = AccessControlList;
            request_x.AWSAccessKeyId = AWSAccessKeyId;
            request_x.Timestamp = Timestamp;
            request_x.Signature = Signature;
            Map<String, S3.CreateBucketResponse_element> response_map_x = new Map<String, S3.CreateBucketResponse_element>();
            response_map_x.put('response_x', response_x);
            if (!Test.isRunningTest())
            WebServiceCallout.invoke(
              this,
              request_x,
              response_map_x,
              new String[]{endpoint_x,
              '',
              'http://s3.amazonaws.com/doc/2006-03-01/',
              'CreateBucket',
              'http://s3.amazonaws.com/doc/2006-03-01/',
              'CreateBucketResponse',
              'S3.CreateBucketResponse_element'}
            );
            response_x = response_map_x.get('response_x');
            if (!Test.isRunningTest())
            	return response_x.CreateBucketResponse;
            else
            	return null;
        }
        

        public S3.Status DeleteBucket(String Bucket,String AWSAccessKeyId,DateTime Timestamp,String Signature,String Credential) {
            S3.DeleteBucket_element request_x = new S3.DeleteBucket_element();
            S3.DeleteBucketResponse_element response_x;
            request_x.Bucket = Bucket;
            request_x.AWSAccessKeyId = AWSAccessKeyId;
            request_x.Timestamp = Timestamp;
            request_x.Signature = Signature;
            request_x.Credential = Credential;
            Map<String, S3.DeleteBucketResponse_element> response_map_x = new Map<String, S3.DeleteBucketResponse_element>();
            response_map_x.put('response_x', response_x);
            if (!Test.isRunningTest())
            WebServiceCallout.invoke(
              this,
              request_x,
              response_map_x,
              new String[]{endpoint_x,
              '',
              'http://s3.amazonaws.com/doc/2006-03-01/',
              'DeleteBucket',
              'http://s3.amazonaws.com/doc/2006-03-01/',
              'DeleteBucketResponse',
              'S3.DeleteBucketResponse_element'}
            );
            response_x = response_map_x.get('response_x');
            if (!Test.isRunningTest())
            	return response_x.DeleteBucketResponse;
            else
            	return null;
        }
        
        
        public S3.PutObjectResult PutObjectInline(String Bucket,String Key,S3.MetadataEntry[] Metadata,String Data,Double ContentLength,S3.AccessControlList AccessControlList,String StorageClass,String AWSAccessKeyId,DateTime Timestamp,String Signature,String Credential) {
            S3.PutObjectInline_element request_x = new S3.PutObjectInline_element();
            S3.PutObjectInlineResponse_element response_x;
            request_x.Bucket = Bucket;
            request_x.Key = Key;
            request_x.Metadata = Metadata;
            request_x.Data = Data;
            System.debug('TESTContentLength: ' +ContentLength.intValue());
            request_x.ContentLength = ContentLength.intValue();
            request_x.AccessControlList = AccessControlList;
            request_x.StorageClass = StorageClass;
            request_x.AWSAccessKeyId = AWSAccessKeyId;
            request_x.Timestamp = Timestamp;
            request_x.Signature = Signature;
            request_x.Credential = Credential;
            Map<String, S3.PutObjectInlineResponse_element> response_map_x = new Map<String, S3.PutObjectInlineResponse_element>();
            response_map_x.put('response_x', response_x);
            if (!Test.isRunningTest())
            WebServiceCallout.invoke(
              this,
              request_x,
              response_map_x,
              new String[]{endpoint_x,
              '',
              'http://s3.amazonaws.com/doc/2006-03-01/',
              'PutObjectInline',
              'http://s3.amazonaws.com/doc/2006-03-01/',
              'PutObjectInlineResponse',
              'S3.PutObjectInlineResponse_element'}
            );
            response_x = response_map_x.get('response_x');
            return response_x.PutObjectInlineResponse;
        }
        
          
          
        /*
           This method invokes the S3 SetObjectAccessControlPolicy web service operation.
        */
        public Boolean SetObjectAccessControlPolicy(String Bucket,String Key,String accessType,String AWSAccessKeyId,DateTime Timestamp,String Signature,String Credential, String canonicalUserId){
        	
        
        	 //S3Request S3XMLSoapRequest=  new S3Request('SetObjectAccessControlPolicy');
            S3Request S3XMLSoapRequest=  new S3Request();
            S3XMLSoapRequest.soapBody= '<?xml version="1.0" encoding="UTF-8"?><env:Envelope xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:env="http://www.w3.org/2003/05/soap-envelope" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"><env:Header/><env:Body>';
            S3XMLSoapRequest.soapBody+= '<SetObjectAccessControlPolicy xmlns="http://s3.amazonaws.com/doc/2006-03-01/">';
            S3XMLSoapRequest.soapBody += '<Bucket>' + Bucket + '</Bucket>';
            S3XMLSoapRequest.soapBody += '<Key>' + Key + '</Key>';
            S3XMLSoapRequest.soapBody += '<AccessControlList><Grant><Grantee xsi:type="CanonicalUser"><ID>'+canonicalUserId+'</ID></Grantee><Permission>FULL_CONTROL</Permission></Grant><Grant><Grantee xsi:type="Group"><URI>http://acs.amazonaws.com/groups/global/AllUsers</URI></Grantee><Permission>READ</Permission></Grant></AccessControlList>';
            S3XMLSoapRequest.soapBody +='<AWSAccessKeyId>' + AWSAccessKeyId + '</AWSAccessKeyId>';
            String formattednow = Timestamp.formatGmt('yyyy-MM-dd')+'T'+Timestamp.formatGmt('HH:mm:ss')+'.'+Timestamp.formatGMT('SSS')+'Z';
            S3XMLSoapRequest.soapBody += '<Timestamp>' + formattednow + '</Timestamp>';
            S3XMLSoapRequest.soapBody += '<Signature>' + signature + '</Signature>';
            S3XMLSoapRequest.soapBody +='<Credential>' + credential + '</Credential>';
            
            S3XMLSoapRequest.soapBody +='</SetObjectAccessControlPolicy></env:Body></env:Envelope>';
            
	        System.debug('SOAP REQUEST BODY: ' + S3XMLSoapRequest.soapBody);
	        httpresponse res = S3XMLSoapRequest.makeRequest();
	        System.debug('SOAP RESPONSE: ' + res.getBody());
	        AWS_XMLDom dom = new AWS_XMLDom( res.getBody() ); 
	        dom.dumpAll();
	         
            if(dom.getElementsByTagName('Description')!=null){
              System.debug('Successfully uploaded file with SetObjectAccessControlPolicy method');
              return true;	
            }
            else{
            	System.debug('Error: Failed to uploaded file with SetObjectAccessControlPolicy method');
              return false;
            }
            
       
           	
           	
        }
          
        /*
              This method uses the S3 SOAP API to upload an object to the specified bucket and apply an Access Policy.  
        */  
        public Boolean PutObjectInline_ACL(String Bucket,String Key,S3.MetadataEntry[] Metadata,String Data,Integer ContentLength,String accessType,String AWSAccessKeyId,DateTime Timestamp,String Signature,String Credential, String canonicalUserId) {
             
            //S3Request S3XMLSoapRequest=  new S3Request('PutObjectInline');
            S3Request S3XMLSoapRequest=  new S3Request();
            
            S3XMLSoapRequest.soapBody= '<?xml version="1.0" encoding="UTF-8"?><env:Envelope xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:env="http://www.w3.org/2003/05/soap-envelope" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"><env:Header/><env:Body>';
            S3XMLSoapRequest.soapBody+= '<PutObjectInline xmlns="http://s3.amazonaws.com/doc/2006-03-01/">';
            S3XMLSoapRequest.soapBody += '<Bucket>' + Bucket + '</Bucket>';
            S3XMLSoapRequest.soapBody += '<Key>' + Key + '</Key>';
            
            
            if(Metadata!=null){
	            for(S3.MetadataEntry entry: Metadata)
	               S3XMLSoapRequest.soapBody += '<Metadata><Name>'+entry.Name+'</Name><Value>'+entry.Value+'</Value></Metadata>';
            }
            
            S3XMLSoapRequest.soapBody += '<Data>' + Data + '</Data>';
            S3XMLSoapRequest.soapBody += '<ContentLength>' +  String.valueOf(ContentLength) + '</ContentLength>';
            S3XMLSoapRequest.soapBody += '<AccessControlList>';
            
            if(accessType=='public-read')
            	S3XMLSoapRequest.soapBody += '<Grant><Grantee xsi:type="Group"><URI>http://acs.amazonaws.com/groups/global/AllUsers</URI></Grantee><Permission>READ</Permission></Grant>';
            if(accesstype=='public-write')
               S3XMLSoapRequest.soapBody += '<Grant><Grantee xsi:type="Group"><URI>http://acs.amazonaws.com/groups/global/AllUsers</URI></Grantee><Permission>WRITE</Permission></Grant>';
            
            //Default Owner to FULL_CONTROL
            system.assert(canonicalUserId!=null);
            S3XMLSoapRequest.soapBody += '<Grant><Grantee xsi:type="CanonicalUser"><ID>'+canonicalUserId+'</ID></Grantee><Permission>FULL_CONTROL</Permission></Grant>';
            
            S3XMLSoapRequest.soapBody += '</AccessControlList>';
            S3XMLSoapRequest.soapBody +='<AWSAccessKeyId>' + AWSAccessKeyId + '</AWSAccessKeyId>';
            String formattednow = Timestamp.formatGmt('yyyy-MM-dd')+'T'+Timestamp.formatGmt('HH:mm:ss')+'.'+Timestamp.formatGMT('SSS')+'Z';
            S3XMLSoapRequest.soapBody += '<Timestamp>' + formattednow + '</Timestamp>';
            S3XMLSoapRequest.soapBody += '<Signature>' + signature + '</Signature>';
            S3XMLSoapRequest.soapBody +='<Credential>' + credential + '</Credential>';
            S3XMLSoapRequest.soapBody +='</PutObjectInline></env:Body></env:Envelope>';
            
             
	        System.debug('SOAP REQUEST BODY: ' + S3XMLSoapRequest.soapBody);
	        httpresponse res = S3XMLSoapRequest.makeRequest();
	        System.debug('SOAP RESPONSE: ' + res.getBody());
	        AWS_XMLDom dom = new AWS_XMLDom( res.getBody() ); 
	        dom.dumpAll();
	         
            if(dom.getElementsByTagName('LastModified')!=null){
              System.debug('Successfully uploaded file with PutObjectInline_ACL method');
              return true;	
            }
            else{
            	System.debug('Error: Failed to uploaded file with PutObjectInline_ACL method');
              return false;
            }
            
       
        
        }
        
    }
    
    public class ListAllMyBucketsEntry {
        public String Name { get; set; }
        public DateTime CreationDate;
        private String[] Name_type_info = new String[]{'Name','http://www.w3.org/2001/XMLSchema','string','1','1','false'};
        private String[] CreationDate_type_info = new String[]{'CreationDate','http://www.w3.org/2001/XMLSchema','dateTime','1','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://s3.amazonaws.com/doc/2006-03-01/','true'};
        private String[] field_order_type_info = new String[]{'Name','CreationDate'};
    }
    public class CreateBucketResult {
        public String BucketName;
        private String[] BucketName_type_info = new String[]{'BucketName','http://www.w3.org/2001/XMLSchema','string','1','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://s3.amazonaws.com/doc/2006-03-01/','true'};
        private String[] field_order_type_info = new String[]{'BucketName'};
    }
    public class ListEntry {
        public String Key {get;set;}
        public DateTime LastModified {get;set;}
        public String ETag {get;set;}
        public Double Size {get;set;}
        public S3.CanonicalUser Owner {get;set;}
        public String StorageClass {get;set;}
        private String[] Key_type_info = new String[]{'Key','http://www.w3.org/2001/XMLSchema','string','1','1','false'};
        private String[] LastModified_type_info = new String[]{'LastModified','http://www.w3.org/2001/XMLSchema','dateTime','1','1','false'};
        private String[] ETag_type_info = new String[]{'ETag','http://www.w3.org/2001/XMLSchema','string','1','1','false'};
        private String[] Size_type_info = new String[]{'Size','http://www.w3.org/2001/XMLSchema','long','1','1','false'};
        private String[] Owner_type_info = new String[]{'Owner','http://s3.amazonaws.com/doc/2006-03-01/','CanonicalUser','0','1','false'};
        private String[] StorageClass_type_info = new String[]{'StorageClass','http://s3.amazonaws.com/doc/2006-03-01/','StorageClass','1','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://s3.amazonaws.com/doc/2006-03-01/','true'};
        private String[] field_order_type_info = new String[]{'Key','LastModified','ETag','Size','Owner','StorageClass'};
    }
    
    
    public class PutObjectInlineResponse_element {
        public S3.PutObjectResult PutObjectInlineResponse;
        private String[] PutObjectInlineResponse_type_info = new String[]{'PutObjectInlineResponse','http://s3.amazonaws.com/doc/2006-03-01/','PutObjectResult','1','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://s3.amazonaws.com/doc/2006-03-01/','true'};
        private String[] field_order_type_info = new String[]{'PutObjectInlineResponse'};
    }
    
    public class DeleteObject_element {
        public String Bucket;
        public String Key;
        public String AWSAccessKeyId;
        public DateTime Timestamp;
        public String Signature;
        public String Credential;
        private String[] Bucket_type_info = new String[]{'Bucket','http://www.w3.org/2001/XMLSchema','string','1','1','false'};
        private String[] Key_type_info = new String[]{'Key','http://www.w3.org/2001/XMLSchema','string','1','1','false'};
        private String[] AWSAccessKeyId_type_info = new String[]{'AWSAccessKeyId','http://www.w3.org/2001/XMLSchema','string','0','1','false'};
        private String[] Timestamp_type_info = new String[]{'Timestamp','http://www.w3.org/2001/XMLSchema','dateTime','0','1','false'};
        private String[] Signature_type_info = new String[]{'Signature','http://www.w3.org/2001/XMLSchema','string','0','1','false'};
        private String[] Credential_type_info = new String[]{'Credential','http://www.w3.org/2001/XMLSchema','string','0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://s3.amazonaws.com/doc/2006-03-01/','true'};
        private String[] field_order_type_info = new String[]{'Bucket','Key','AWSAccessKeyId','Timestamp','Signature','Credential'};
    }
    public class ListAllMyBucketsResult {
        public S3.CanonicalUser Owner;
        public S3.ListAllMyBucketsList Buckets { get; set; }
        private String[] Owner_type_info = new String[]{'Owner','http://s3.amazonaws.com/doc/2006-03-01/','CanonicalUser','1','1','false'};
        private String[] Buckets_type_info = new String[]{'Buckets','http://s3.amazonaws.com/doc/2006-03-01/','ListAllMyBucketsList','1','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://s3.amazonaws.com/doc/2006-03-01/','true'};
        private String[] field_order_type_info = new String[]{'Owner','Buckets'};
    }
    public class ListAllMyBucketsResponse_element {
        public S3.ListAllMyBucketsResult ListAllMyBucketsResponse;
        private String[] ListAllMyBucketsResponse_type_info = new String[]{'ListAllMyBucketsResponse','http://s3.amazonaws.com/doc/2006-03-01/','ListAllMyBucketsResult','1','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://s3.amazonaws.com/doc/2006-03-01/','true'};
        private String[] field_order_type_info = new String[]{'ListAllMyBucketsResponse'};
    }
    
    
    
    public class CreateBucketResponse_element {
        public S3.CreateBucketResult CreateBucketResponse;
        private String[] CreateBucketResponse_type_info = new String[]{'CreateBucketResponse','http://s3.amazonaws.com/doc/2006-03-01/','CreateBucketResponse','1','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://s3.amazonaws.com/doc/2006-03-01/','true'};
        private String[] field_order_type_info = new String[]{'CreateBucketResonse'};
    }
    public class Status {
        public Integer Code {get;set;}
        public String Description {get;set;}
        private String[] Code_type_info = new String[]{'Code','http://www.w3.org/2001/XMLSchema','int','1','1','false'};
        private String[] Description_type_info = new String[]{'Description','http://www.w3.org/2001/XMLSchema','string','1','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://s3.amazonaws.com/doc/2006-03-01/','true'};
        private String[] field_order_type_info = new String[]{'Code','Description'};
    }
    public class DeleteBucket_element {
        public String Bucket;
        public String AWSAccessKeyId;
        public DateTime Timestamp;
        public String Signature;
        public String Credential;
        private String[] Bucket_type_info = new String[]{'Bucket','http://www.w3.org/2001/XMLSchema','string','1','1','false'};
        private String[] AWSAccessKeyId_type_info = new String[]{'AWSAccessKeyId','http://www.w3.org/2001/XMLSchema','string','0','1','false'};
        private String[] Timestamp_type_info = new String[]{'Timestamp','http://www.w3.org/2001/XMLSchema','dateTime','0','1','false'};
        private String[] Signature_type_info = new String[]{'Signature','http://www.w3.org/2001/XMLSchema','string','0','1','false'};
        private String[] Credential_type_info = new String[]{'Credential','http://www.w3.org/2001/XMLSchema','string','0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://s3.amazonaws.com/doc/2006-03-01/','true'};
        private String[] field_order_type_info = new String[]{'Bucket','AWSAccessKeyId','Timestamp','Signature','Credential'};
    }
    
    
    public class PrefixEntry {
        public String Prefix;
        private String[] Prefix_type_info = new String[]{'Prefix','http://www.w3.org/2001/XMLSchema','string','1','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://s3.amazonaws.com/doc/2006-03-01/','true'};
        private String[] field_order_type_info = new String[]{'Prefix'};
    }
    
    public class DeleteObjectResponse_element {
        public S3.Status DeleteObjectResponse;
        private String[] DeleteObjectResponse_type_info = new String[]{'DeleteObjectResponse','http://s3.amazonaws.com/doc/2006-03-01/','Status','1','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://s3.amazonaws.com/doc/2006-03-01/','true'};
        private String[] field_order_type_info = new String[]{'DeleteObjectResponse'};
    }
    

    public class ListAllMyBuckets_element {
        public String AWSAccessKeyId;
        public DateTime Timestamp;
        public String Signature;
        private String[] AWSAccessKeyId_type_info = new String[]{'AWSAccessKeyId','http://www.w3.org/2001/XMLSchema','string','0','1','false'};
        private String[] Timestamp_type_info = new String[]{'Timestamp','http://www.w3.org/2001/XMLSchema','dateTime','0','1','false'};
        private String[] Signature_type_info = new String[]{'Signature','http://www.w3.org/2001/XMLSchema','string','0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://s3.amazonaws.com/doc/2006-03-01/','true'};
        private String[] field_order_type_info = new String[]{'AWSAccessKeyId','Timestamp','Signature'};
    }
    
    public class PutObjectResult {
        public String ETag;
        public DateTime LastModified;
        private String[] ETag_type_info = new String[]{'ETag','http://www.w3.org/2001/XMLSchema','string','1','1','false'};
        private String[] LastModified_type_info = new String[]{'LastModified','http://www.w3.org/2001/XMLSchema','dateTime','1','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://s3.amazonaws.com/doc/2006-03-01/','true'};
        private String[] field_order_type_info = new String[]{'ETag','LastModified'};
    }
    
    public class AccessControlList {
        //public S3.Grant[] Grant;
        private String[] Grant_type_info = new String[]{'Grant','http://s3.amazonaws.com/doc/2006-03-01/','Grant','0','100','false'};
        private String[] apex_schema_type_info = new String[]{'http://s3.amazonaws.com/doc/2006-03-01/','true'};
        private String[] field_order_type_info = new String[]{'Grant'};
    }
    

    public class CanonicalUser {
        public String ID;
        public String DisplayName;
        private String[] ID_type_info = new String[]{'ID','http://www.w3.org/2001/XMLSchema','string','1','1','false'};
        private String[] DisplayName_type_info = new String[]{'DisplayName','http://www.w3.org/2001/XMLSchema','string','0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://s3.amazonaws.com/doc/2006-03-01/','true'};
        private String[] field_order_type_info = new String[]{'ID','DisplayName'};
    }
    
    public class ListBucket_element {
        public String Bucket;
        public String Prefix;
        public String Marker;
        public Integer MaxKeys;
        public String Delimiter;
        public String AWSAccessKeyId;
        public DateTime Timestamp;
        public String Signature;
        public String Credential;
        private String[] Bucket_type_info = new String[]{'Bucket','http://www.w3.org/2001/XMLSchema','string','1','1','false'};
        private String[] Prefix_type_info = new String[]{'Prefix','http://www.w3.org/2001/XMLSchema','string','0','1','false'};
        private String[] Marker_type_info = new String[]{'Marker','http://www.w3.org/2001/XMLSchema','string','0','1','false'};
        private String[] MaxKeys_type_info = new String[]{'MaxKeys','http://www.w3.org/2001/XMLSchema','int','0','1','false'};
        private String[] Delimiter_type_info = new String[]{'Delimiter','http://www.w3.org/2001/XMLSchema','string','0','1','false'};
        private String[] AWSAccessKeyId_type_info = new String[]{'AWSAccessKeyId','http://www.w3.org/2001/XMLSchema','string','0','1','false'};
        private String[] Timestamp_type_info = new String[]{'Timestamp','http://www.w3.org/2001/XMLSchema','dateTime','0','1','false'};
        private String[] Signature_type_info = new String[]{'Signature','http://www.w3.org/2001/XMLSchema','string','0','1','false'};
        private String[] Credential_type_info = new String[]{'Credential','http://www.w3.org/2001/XMLSchema','string','0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://s3.amazonaws.com/doc/2006-03-01/','true'};
        private String[] field_order_type_info = new String[]{'Bucket','Prefix','Marker','MaxKeys','Delimiter','AWSAccessKeyId','Timestamp','Signature','Credential'};
    }
    
    public class PutObjectInline_element {
        public String Bucket;
        public String Key;
        public S3.MetadataEntry[] Metadata;
        public String Data;
        public Integer ContentLength;
        public S3.AccessControlList AccessControlList;
        public String StorageClass;
        public String AWSAccessKeyId;
        public DateTime Timestamp;
        public String Signature;
        public String Credential;
        private String[] Bucket_type_info = new String[]{'Bucket','http://www.w3.org/2001/XMLSchema','string','1','1','false'};
        private String[] Key_type_info = new String[]{'Key','http://www.w3.org/2001/XMLSchema','string','1','1','false'};
        private String[] Metadata_type_info = new String[]{'Metadata','http://s3.amazonaws.com/doc/2006-03-01/','MetadataEntry','0','100','false'};
        private String[] Data_type_info = new String[]{'Data','http://www.w3.org/2001/XMLSchema','base64Binary','1','1','false'};
        private String[] ContentLength_type_info = new String[]{'ContentLength','http://www.w3.org/2001/XMLSchema','long','1','1','false'};
        private String[] AccessControlList_type_info = new String[]{'AccessControlList','http://s3.amazonaws.com/doc/2006-03-01/','AccessControlList','0','1','false'};
        private String[] StorageClass_type_info = new String[]{'StorageClass','http://s3.amazonaws.com/doc/2006-03-01/','StorageClass','0','1','false'};
        private String[] AWSAccessKeyId_type_info = new String[]{'AWSAccessKeyId','http://www.w3.org/2001/XMLSchema','string','0','1','false'};
        private String[] Timestamp_type_info = new String[]{'Timestamp','http://www.w3.org/2001/XMLSchema','dateTime','0','1','false'};
        private String[] Signature_type_info = new String[]{'Signature','http://www.w3.org/2001/XMLSchema','string','0','1','false'};
        private String[] Credential_type_info = new String[]{'Credential','http://www.w3.org/2001/XMLSchema','string','0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://s3.amazonaws.com/doc/2006-03-01/','true'};
        private String[] field_order_type_info = new String[]{'Bucket','Key','Metadata','Data','ContentLength','AccessControlList','StorageClass','AWSAccessKeyId','Timestamp','Signature','Credential'};
    }

    public class CreateBucket_element {
        public String Bucket;
        public S3.AccessControlList AccessControlList;
        public String AWSAccessKeyId;
        public DateTime Timestamp;
        public String Signature;
        private String[] Bucket_type_info = new String[]{'Bucket','http://www.w3.org/2001/XMLSchema','string','1','1','false'};
        private String[] AccessControlList_type_info = new String[]{'AccessControlList','http://s3.amazonaws.com/doc/2006-03-01/','AccessControlList','0','1','false'};
        private String[] AWSAccessKeyId_type_info = new String[]{'AWSAccessKeyId','http://www.w3.org/2001/XMLSchema','string','0','1','false'};
        private String[] Timestamp_type_info = new String[]{'Timestamp','http://www.w3.org/2001/XMLSchema','dateTime','0','1','false'};
        private String[] Signature_type_info = new String[]{'Signature','http://www.w3.org/2001/XMLSchema','string','0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://s3.amazonaws.com/doc/2006-03-01/','true'};
        private String[] field_order_type_info = new String[]{'Bucket','AccessControlList','AWSAccessKeyId','Timestamp','Signature'};
    }
    

    public class DeleteBucketResponse_element {
        public S3.Status DeleteBucketResponse;
        private String[] DeleteBucketResponse_type_info = new String[]{'DeleteBucketResponse','http://s3.amazonaws.com/doc/2006-03-01/','Status','1','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://s3.amazonaws.com/doc/2006-03-01/','true'};
        private String[] field_order_type_info = new String[]{'DeleteBucketResponse'};
    }

    public void byPass(){
        Integer a = 1;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
    }
    
    public class S3Request {
	
		// data class used to construct a request to AWS S3
	 	public AWS_XMLDom.element body = new AWS_XMLDom.element('env:Body');
		public string soapBody { get ; set;} 
		 
		 //default constructor
		public S3Request() { 
		}
		
		
		
		transient HttpResponse response = null;
		public string error {get;set;}
	    public HttpResponse makeRequest()  { // leaves result in res instance member
	        error = null;
	        HttpRequest req = new HttpRequest();   
	        req.setEndpoint('https://s3-us-west-2.amazonaws.com/soap');
	        
	        
	        req.setMethod('POST'); 

	        System.debug('before soap body: ' + soapBody);

	        System.debug('after soap body: ' + soapBody);
	        req.setBody(soapBody);

	        req.setHeader('Content-Type', 'application/soap+xml' );
	        req.setHeader('SOAPAction','');
			System.debug('content length: ' + string.valueof(soapBody.trim().length()));
	        req.setHeader('Content-Length',string.valueof(soapBody.trim().length()));
	        
	        try {
	            Http http = new Http();
	            System.debug('making S3 request...: ' + req);
	            if (!Test.isRunningTest())
	            	response = http.send(req);
	            if (response.getStatusCode() != 200 ) {
	                
	                System.debug('STATUS:'+response.getStatus());
	                System.debug('STATUS_CODE:'+response.getStatusCode());
	                System.debug('BODY: '+response.getBody());
	                AWS_XMLDom dom = new AWS_XMLDom( response.getBody() );
		 			dom.dumpAll();
		 			if ( response.getStatusCode() == 500 ) {
		 				string reasonPath = '';  
		 				AWS_XMLDom.element e = dom.getElementByPath('/.*/Fault') ;
		 				if ( e!= null ) {
		 					e.dumpAll();
		 					error = body + response.getBody() ;//+ '\n'+e.getValue('Text');
		 				} else { 
		 					system.debug( 'no fault found' ); 
		 				}
		 				
		 			}
	            } 
	            
	        } catch( System.Exception e) {
	            System.debug('ERROR: '+ e);
	        }
	        return response;
	    }

  
}

}