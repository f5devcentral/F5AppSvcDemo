#!/bin/bash
echo "Provisioning ASM on BIG-IP"
ssh admin@bigip.example.com modify sys provision asm level nominal
echo "Saving BIG-IP config"
ssh admin@bigip.example.com  save sys config