## How to Generate public and private keys in PEM format for OCI API Keys. 

1. Generate private key using openssl 
```
openssl genrsa -out private_key.pem 2048
```
2. Generate Public key using private key .
```
 openssl rsa -in private_key.pem -pubout -out public_key.pem
```

3. Get the fingerprint value of the keys. 
```
openssl rsa -pubin -in public_key.pem -outform DER | openssl dgst -md5 -c
```

4. To generate pblic key from private key PEM file. 
```
openssl rsa -in private_key.pem -pubout -out public_key.pem

```