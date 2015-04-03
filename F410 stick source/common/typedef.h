typedef unsigned char            INT8U;   // Unsigned  8 bit quantity
typedef signed   char            INT8S;   // Signed    8 bit quantity
typedef unsigned short           INT16U;  // Unsigned 16 bit quantity
typedef signed   short           INT16S;  // Signed   16 bit quantity
typedef unsigned long            INT32U;  // Unsigned 32 bit quantity
typedef signed   long            INT32S;  // Signed   32 bit quantity

typedef volatile unsigned char   VINT8U;
typedef volatile unsigned short  VINT16U;
typedef volatile unsigned long   VINT32U;


#define CLR_BIT(reg, bit)      reg &= ~(1 << bit)
#define SET_BIT(reg, bit)      reg |= 1 << bit


#define ITEMNUM(x)            (sizeof(x) / sizeof((x)[0]))     // tömb elemeinek száma

#ifndef MIN
   #define MIN(x,y)	((x)<(y)?(x):(y))
#endif

#ifndef MAX
   #define MAX(x,y)	((x)>(y)?(x):(y))
#endif