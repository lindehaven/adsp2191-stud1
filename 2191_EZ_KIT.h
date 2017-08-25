
/*  TX Config Register bits */

#define TSPEN       1                   /* Transmit enable */
#define ICLK        2                   /* internal clock */
#define ZERO_FILL   0
#define SIGN_EXT    4
#define MU_LAW      8
#define A_LAW       0xC
#define LSB_FIRST   0x10
#define BITS16      0x1E0
#define BITS8	    0x0E0
#define ITFS        0x200               /* internal xmit frame sync */
#define TFSR        0x400               /* xmit frame sync required */
#define DITFS       0x800
#define LTFS        0x1000              /* active low frame sync */
#define LATFS       0x2000              /* late frame sync */
#define CKRE        0x4000              /* sample data on rising edge of bitclk */
#define H100        0x8000              /* H100 compatability */

   
/*  Rx Config Register bits */
#define RSPEN       1                   /* rx enable */
#define IRFS        0x200               /* use internal frame sync */
#define RFSR        0x400               /* rx frame sync required */
#define LRFS        0x1000              /* active lo rx frame sync */
#define LARFS       0x2000              /* late rx frame sync */


