#PS1=' ( ._.)φ__ \w > '
#cyan
PS1="\`if [ \$? = 0 ]; then echo \[\e[36m\]'( ._.)φ__ \w > '\[\e[0m\]; else echo \[\e[31m\]'( o_o)φ__ \w > '\[\e[0m\]; fi\`"
#green
# PS1="\`if [ \$? = 0 ]; then echo \[\e[32m\]'( ._.)φ__ \w > '\[\e[0m\]; else echo \[\e[31m\]'( o_o)φ__ \w > '\[\e[0m\]; fi\`"

export PATH="$HOME/.local/bin:/usr/sbin/:$HOME/.node_modules_global/bin:$PATH"

#aliases
alias ls='ls --color=auto'
alias cls='clear'
alias cdls='clear && cd'
alias vi='vim'
alias sur='su root'
alias rm~='rm -R *~;rm .*~'
#alias por el semestre
alias decimo='cd ~/Docu/10no/'
#java
alias j="javac -d classes/"
alias jm="javac -d classes/ Main.java"
alias jjm="java -classpath classes/ Main"
#hdmi
alias hdmi="xrandr --output HDMI1 --mode 1280x720"

#append any additional sh scripts found in /etc/profile.d/:
for profile_script in /etc/profile.d/*.sh ; do
    if [ -x $profile_script ]; then
        . $profile_script
    fi
done
unset profile_script
