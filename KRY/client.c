#include "openssl/bio.h"
#include "openssl/ssl.h"
#include "openssl/err.h"


static int verify_callback(int preverify_ok, X509_STORE_CTX *ctx)
{
  // Uvnitr teto funkce se provadi kontrola certifikatu
  // Na zaklade jeji navratove hodnoty handshake skonci bud failem, nebo uspechem.
  // Tohle je ta tezka cast...

  .
  .
  .

  //
  
  return retval; 
}


int main()
{
  SSL_CTX *ctx;  // CTX struktura obsahuje vsechna nastaveni souvisejici s SSL spojenim obecne.

  SSL * ssl; // SSL struktura obsahuje vsechny detaily o 1 konkrétním spojení. Je sestavena na zaklade 
             // informaci ulozenych v CTX strukture. Lze na to nahlizet, jako ze CTX je predpis a SSL
             // je konkretni instance vytvorena podle toho predpisu.

  BIO * bio; // Nejaka hruzostrasnost z openssl, kterou lze pouzivat jako mezivrstvu pro pristup 
             // k souborum/pameti/socketum. Jde to i bez ni, ale oskliveji a nevim presne jak xD


  // Inicializace CTX struktury do modu "client"
  ctx = SSL_CTX_new(SSLv23_client_method());

  // Tohle nacte do pameti nejakej bordel, bez ktereho to nefunguje :)
  SSL_load_error_strings();	
  OpenSSL_add_ssl_algorithms(); 
  ERR_load_BIO_strings();

  // Touto funkci rekneme, ze chceme, aby pri SSL handshaku byla zavolana
  // nase funkce 'verify_callback', uvnitr ktere budeme kontrolovat platnost
  // certifikatu, jenz nam predlozila druha strana. 
  SSL_CTX_set_verify(ctx, SSL_VERIFY_PEER, verify_callback);

  // Vytvorime instanci te mysteriozni mezivrstvy BIO a predame ji
  // informace z CTX a kontrolu nad SSL strukturou
  bio = BIO_new_ssl_connect(ctx);
  BIO_get_ssl(bio, &ssl);

  // Posilani/prijeti zpravy skrz SSL obcas muze failnout kvuli nejakym
  // internim potrebam SSL spojeni... Po prepnuti do modu AUTO_RETRY
  // se o uz o tento typ problemu nemusime starat, bude si je to resit samo.
  SSL_set_mode(*ssl, SSL_MODE_AUTO_RETRY);

  // Nastavime cilovy port a adresu
  BIO_set_conn_port(bio, "6666");
  BIO_set_conn_hostname(bio, "127.0.0.1");

  if(bio == NULL)
    ERR_print_errors_fp(stderr);

  // A nyni se konecne pokusime pripojit k serveru. Toto volani v sobe
  // zahrnuje udelani celeho SSL handshaku.
  BIO_do_connect(bio)

  // Nyni muzeme poslat nejakou zpravu
  n = BIO_write(bio, "ahoj", sizeof("ahoj"))
  if (n <= 0)
    ERR_print_errors_fp(stderr);

  // A pripadne i dostat odpoved
  BIO_read(bio, msg_buffer, sizeof(msg_buffer));

  // Uz nic nebudeme delat, free vsechno
  SSL_CTX_free(ctx);
  BIO_free_all(bio); 

  return ALL_OK;
}
