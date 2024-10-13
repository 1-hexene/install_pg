#!/bin/bash

SCRIPTS_DIR="$HOME/.scripts"
if [ ! -d "$SCRIPTS_DIR" ]; then
    mkdir "$SCRIPTS_DIR"
    echo "Directory $SCRIPTS_DIR created."
else
    echo "Directory $SCRIPTS_DIR already exists."
fi

if ! grep -q "$SCRIPTS_DIR" ~/.bashrc; then
    echo "export PATH=\"\$PATH:$SCRIPTS_DIR\"" >> ~/.bashrc
    echo "Added $SCRIPTS_DIR to PATH in ~/.bashrc."
else
    echo "$SCRIPTS_DIR is already in PATH."
fi

PG_FILE="$SCRIPTS_DIR/pg"
if [ -f "$PG_FILE" ]; then
    echo -e "\e[31mWARNING:The 'pg' file already exists and will be overwritten.\e[0m"
fi

cat > "$PG_FILE" << 'EOF'
#!/bin/bash
if [ "$1" = "go" ]; then
    echo -e "\e[44m[ Go! ]\e[0m  \e[34mStarting PostgreSQL server...\e[0m"
    sudo service postgresql start
elif [ "$1" = "stop" ]; then
    echo -e "\e[43m[Stop!]\e[0m \e[33mStopping PostgreSQL server...\e[0m"
    sudo service postgresql stop
else
    echo -e "\e[41m[ERROR]\e[0m \e[31mPlease use \"pg go\" or \"pg stop\"\e[0m"
fi
EOF

echo "pg script created in $SCRIPTS_DIR."

chmod +x "$PG_FILE"
echo "Executable permission granted to pg script."

echo -e "\e[32mSetup complete.\e[0m You can now use 'pg go' or 'pg stop' after running following command:"
echo -e "\t\e[42msource ~/.bashrc \e[0m"
