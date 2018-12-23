#include <linux/init.h>   //Macros used to mark up functions e.g. __init __exit
#include <linux/module.h> //Core header for loading LKMs into the kernel
#include <linux/kernel.h> //Contains types,macros,functions for the kernel

MODULE_LICENSE("GPL");
MODULE_AUTHOR("Bill Liu");

static int __init module_demo_init(void)
{
    printk("Hello world, showing kernel module demo now\n");
    return 0;
}

static void __exit module_demo_exit(void)
{
    printk("Goodbye world,exit kernel module demo\n");    
}

module_init(module_demo_init);
module_exit(module_demo_exit);
