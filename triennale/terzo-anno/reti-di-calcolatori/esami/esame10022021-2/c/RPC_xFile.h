/*
 * Please do not edit this file.
 * It was generated using rpcgen.
 */

#ifndef _RPC_XFILE_H_RPCGEN
#define _RPC_XFILE_H_RPCGEN

#include <rpc/rpc.h>


#ifdef __cplusplus
extern "C" {
#endif

#define MAX_NAME_SIZE 30

struct Riga {
	char id[MAX_NAME_SIZE];
	char data[MAX_NAME_SIZE];
	int giorni;
	char modello[MAX_NAME_SIZE];
	int costo;
	char foto[MAX_NAME_SIZE];
};
typedef struct Riga Riga;

struct InputElimina {
	char id[MAX_NAME_SIZE];
};
typedef struct InputElimina InputElimina;

struct InputNoleggia {
	char id[MAX_NAME_SIZE];
	char data[MAX_NAME_SIZE];
	int giorni;
};
typedef struct InputNoleggia InputNoleggia;

#define ESAME_PROG 0x20000014
#define ESAME_VERS 1

#if defined(__STDC__) || defined(__cplusplus)
#define elimina_sci 1
extern  int * elimina_sci_1(InputElimina *, CLIENT *);
extern  int * elimina_sci_1_svc(InputElimina *, struct svc_req *);
#define noleggia_sci 2
extern  int * noleggia_sci_1(InputNoleggia *, CLIENT *);
extern  int * noleggia_sci_1_svc(InputNoleggia *, struct svc_req *);
extern int esame_prog_1_freeresult (SVCXPRT *, xdrproc_t, caddr_t);

#else /* K&R C */
#define elimina_sci 1
extern  int * elimina_sci_1();
extern  int * elimina_sci_1_svc();
#define noleggia_sci 2
extern  int * noleggia_sci_1();
extern  int * noleggia_sci_1_svc();
extern int esame_prog_1_freeresult ();
#endif /* K&R C */

/* the xdr functions */

#if defined(__STDC__) || defined(__cplusplus)
extern  bool_t xdr_Riga (XDR *, Riga*);
extern  bool_t xdr_InputElimina (XDR *, InputElimina*);
extern  bool_t xdr_InputNoleggia (XDR *, InputNoleggia*);

#else /* K&R C */
extern bool_t xdr_Riga ();
extern bool_t xdr_InputElimina ();
extern bool_t xdr_InputNoleggia ();

#endif /* K&R C */

#ifdef __cplusplus
}
#endif

#endif /* !_RPC_XFILE_H_RPCGEN */
