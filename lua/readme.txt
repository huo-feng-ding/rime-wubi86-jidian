* 在实现分号临时英文功能的时候， https://github.com/KyleBing/rime-wubi86-jidian/issues/154 这个功能此功能。  
* 但是临时英文输出的时候按回车键上屏时，前边带了分号，参考 https://github.com/KyleBing/rime-wubi86-jidian/issues/138 加了两个lua文件 log.lua (此文件是为了调试输出内容，需要在processor_enter_skip_prefix.lua文件中引用，此文件是从https://github.com/HowcanoeWang/rime-lua-aux-code/blob/main/lua/log.lua复制而来的，aux_code.lua相关代码也值得参考)， processor_enter_skip_prefix.lua 
* 然后在 wubi86_jidian.schema.yaml 加上这个属性配置  
```
engine:
     - ascii_composer
     - recognizer
     - key_binder
+    - lua_processor@*processor_enter_skip_prefix
     - speller
     - punctuator
     - selector
``` 
