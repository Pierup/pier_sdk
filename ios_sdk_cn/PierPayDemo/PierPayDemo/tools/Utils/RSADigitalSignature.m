//
//  RSADigitalSignature.m
//  PierPayDemo
//
//  Created by zyma on 9/2/15.
//  Copyright (c) 2015 pier. All rights reserved.
//

#import "RSADigitalSignature.h"
#import <string.h>
#import "rsa.h"
#import "pem.h"
#import "md5.h"
#import "bio.h"
#import "sha.h"

@implementation RSADigitalSignature

+ (NSString *)formatPrivateKey:(NSString *)privateKey {
    const char *pstr = [privateKey UTF8String];
    int len = [privateKey length];
    NSMutableString *result = [NSMutableString string];
    [result appendString:@"-----BEGIN PRIVATE KEY-----\n"];
    int index = 0;
    int count = 0;
    while (index < len) {
        char ch = pstr[index];
        if (ch == '\r' || ch == '\n') {
            ++index;
            continue;
        }
        [result appendFormat:@"%c", ch];
        if (++count == 79)
        {
            [result appendString:@"\n"];
            count = 0;
        }
        index++;
    }
    [result appendString:@"\n-----END PRIVATE KEY-----"];
    return result;
}

+ (NSString *)generateSignature:(NSString *)string privateKey:(NSString *)privateKey {
    NSString *signedString = nil;
    NSString *documentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *path = [documentPath stringByAppendingPathComponent:@"RSAPrivateKey"];
    
    privateKey = [RSADigitalSignature formatPrivateKey:privateKey];
    [privateKey writeToFile:path atomically:YES encoding:NSUTF8StringEncoding error:nil];
    
    const char *message = [string cStringUsingEncoding:NSUTF8StringEncoding];
    NSInteger messageLength = strlen(message);
    unsigned char *sig = (unsigned char *)malloc(256);
    unsigned int sig_len;
    int ret = rsa_sign_with_private_key_pem((char *)message, messageLength, sig, &sig_len, (char *)[path UTF8String]);
    if (ret == 1) {
        NSString * base64String = base64StringFromData([NSData dataWithBytes:sig length:sig_len]);
        NSData * UTF8Data = [base64String dataUsingEncoding:NSUTF8StringEncoding];
        signedString = [base64String stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    }
    
    free(sig);
    return signedString;
}

NSString *base64StringFromData(NSData *signature)
{
    int signatureLength = (int)[signature length];
    unsigned char *outputBuffer = (unsigned char *)malloc(2 * 4 * (signatureLength / 3 + 1));
    int outputLength = EVP_EncodeBlock(outputBuffer, [signature bytes], signatureLength);
    outputBuffer[outputLength] = '\0';
    NSString *base64String = [NSString stringWithCString:(char *)outputBuffer encoding:NSASCIIStringEncoding];
    free(outputBuffer);
    return base64String;
}
    

int rsa_sign_with_private_key_pem(char *message, NSInteger message_length
                                  , unsigned char *signature, unsigned int *signature_length
                                  , char *private_key_file_path)
{
    unsigned char sha1[20];
    SHA1((unsigned char *)message, message_length, sha1);
    int success = 0;
    BIO *bio_private = NULL;
    RSA *rsa_private = NULL;
    bio_private = BIO_new(BIO_s_file());
    BIO_read_filename(bio_private, private_key_file_path);
    rsa_private = PEM_read_bio_RSAPrivateKey(bio_private, NULL, NULL, "");
    if (rsa_private != nil) {
        if (1 == RSA_check_key(rsa_private))
        {
            int rsa_sign_valid = RSA_sign(NID_sha1
                                          , sha1, 20
                                          , signature, signature_length
                                          , rsa_private);
            if (1 == rsa_sign_valid)
            {
                success = 1;
            }
        }
        BIO_free_all(bio_private);
    }
    else {
        NSLog(@"rsa_private read error : private key is NULL");
    }
    
    return success;
}


@end
