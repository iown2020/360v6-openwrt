# 奇虎 360 V6 (Qihoo 360V6) 专属 ImmortalWrt 固件云编译

本项目基于官方 **ImmortalWrt openwrt-25.12 稳定分支**，为 360 Wi-Fi 6 路由器（高通 IPQ6018）定制打造，专注**高稳定性、低发热、杜绝掉电死机**，并内置完整的 Passwall 及双核心（Xray + Sing-box）。

---

## 一、核心特性与针对性加固

### 1. 硬件级防断电降载保护
- **CPU 锁频 1.2 GHz**：固件首次开机自动将 4 核 A53 频率上限安全设为 1.2 GHz（原厂设计标称值），抹平激进超频带来的瞬态电流尖峰（di/dt），彻底防止原装老化 12V 1.5A 开关电源触发过流闭锁（Latch-off 关断）。
- **射频温控保护**：5GHz 发射功率限定为 23 dBm (200mW)，2.4GHz 限定为 20 dBm (100mW)，杜绝 FEM 功放满负荷过热与 EVM 恶化。

### 2. 规避高通 ath11k 射频固件死锁
- **纯 WPA2-PSK 协议**：关闭 WPA3-SAE 与 PMF (802.11w) 硬件加密混合状态，杜绝闭源 Q6 DSP 固件竞态死锁。
- **休眠唤醒防踢出**：关闭低 ACK 解关联探测，开启休眠终端轮询抑制，手机息屏不掉线。

### 3. 内核 Order-3 内存防崩溃
- 预留 16MB 连续物理物理内存（`vm.min_free_kbytes=16384`），并激进回收 Slab 缓存，防止大流量下网络驱动原子内存分配失败。

### 4. 科学代理全内置
- **Passwall 套件直接编译入 SquashFS ROM**（非外部模块），开机即用。
- 集成 **Xray-core** 与 **Sing-box** 最新内核，配合 ChinaDNS-NG 实现国内外 DNS 分流。
- 启动脚本预注入 Go 运行时内存限制（`GOMEMLIMIT=45MiB`），彻底阻断 64 位 Go 程序对路由器 512MB 内存的无节制占用。

---

## 二、默认访问信息

| 项目 | 默认值 |
| :--- | :--- |
| **后台 IP** | `192.168.2.1` |
| **登录用户** | `root` |
| **管理密码** | `password` |
| **无线 SSID** | `ImmortalWrt-2.4G` / `ImmortalWrt-5G` |
| **无线密码** | 无密码（初次进入后台请及时设置） |

---

## 三、如何触发云端编译

1. 点击本仓库顶部的 **Actions** 标签。
2. 在左侧选择 **Build 360V6 ImmortalWrt** 工作流。
3. 点击右侧的 **Run workflow** 下拉按钮，再点击绿色 **Run workflow** 按钮启动。
4. 编译耗时约 40~60 分钟。完成后，在仓库右侧的 **Releases** 页面即可直接下载打包好的固件文件：
   - `*squashfs-sysupgrade.bin`：适用于已刷 OpenWrt/ImmortalWrt 的系统在 LuCI 网页端直接升级。
   - `*squashfs-factory.ubi`：适用于原厂或 U-Boot 救砖刷入。

---

## 四、升级刷机方法

若当前路由器已运行 ImmortalWrt 或 OpenWrt：
1. 下载 Release 页面中的 `openwrt-qualcommax-ipq60xx-qihoo_360v6-squashfs-sysupgrade.bin`。
2. 登录当前路由器后台 `http://192.168.2.1`。
3. 进入 **系统 (System) -> 备份/升级 (Backup / Flash Firmware)**。
4. 在“刷写新的固件镜像”处选择该 `.bin` 文件并上传。
5. **建议取消勾选“保留配置”**（不保留旧版本的实验性残留配置，让出厂加固脚本完整生效）。
6. 点击继续，等待路由器重启（约 3 分钟指示灯恢复常亮即可重新访问）。
