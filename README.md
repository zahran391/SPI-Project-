# SPI-Project-
SPI Controller Architecture &amp; Verification in Verilog HDLHappy to share my latest Digital Design &amp; Verification project: A complete, fully parameterizable Serial Peripheral Interface (SPI) Master-Slave Controller implemented in Verilog HD
Building serial communication protocols at the RTL level requires precise synchronization, accurate clock division, and robust timing verification. In this project, I designed and simulated an 8-bit SPI system (Mode 0: CPOL=0, CPHA=0) from scratch.🔑 Key Engineering Highlights:RTL Architecture Design:SPI Master: Implemented with a finite state machine (FSM: IDLE, TRANSFER, DONE) and an internal clock divider to generate SCLK safely from the system clock.SPI Slave: Asynchronous Slave-Select (SS_n) detection with synchronous edge-triggered sampling and shifting.Full-Duplex Data Transfer: Simultaneous data exchange via MOSI and MISO using circular 8-bit Shift Registers.Timing & Synchronization:Sampling: Data is sampled on the Rising Edge of SCLK.Shifting: Next bits are shifted out on the Falling Edge of SCLK (MSB-first execution).Self-Checking Verification Environment:Developed a comprehensive Self-Checking Testbench running 100 randomized test cycles ($random).Implemented automated reference model checking to validate Master RX vs Slave TX and Slave RX vs Master TX.Verified $100\%$ test coverage with zero errors
<img width="1024" height="559" alt="image" src="https://github.com/user-attachments/assets/e9a31a3c-b0e2-407c-a202-cf22c704b568" />
<img width="1508" height="1025" alt="image" src="https://github.com/user-attachments/assets/d715ea15-6eac-43ba-9fbb-d33b6dc380ca" />
<img width="565" height="668" alt="لقطة شاشة 2026-09-11 170005" src="https://github.com/user-attachments/assets/6c9d2d47-413f-4cf9-9b7a-e18470d257a6" />
<img width="1421" height="685" alt="لقطة شاشة 2026-09-11 170041" src="https://github.com/user-attachments/assets/b84dac65-6a18-44ca-ab7e-e28c58cd3a54" />
<img width="940" height="587" alt="لقطة شاشة 2026-09-11 170229" src="https://github.com/user-attachments/assets/70f25d35-0b34-4e27-b139-7b99d7e3fef6" />
<img width="1152" height="695" alt="لقطة شاشة 2026-09-11 170829" src="https://github.com/user-attachments/assets/f1806708-379d-4b35-bd28-c32ad8544073" />
<img width="537" height="577" alt="لقطة شاشة 2026-09-11 171018" src="https://github.com/user-attachments/assets/a1009454-b4aa-4dfc-9cff-e424de0c13cb" />
<img width="1390" height="350" alt="لقطة شاشة 2026-09-11 171047" src="https://github.com/user-attachments/assets/9a5de042-f10e-4e01-aa48-fb3d608792c9" />
<img width="487" height="307" alt="لقطة شاشة 2026-09-11 171155" src="https://github.com/user-attachments/assets/e0258ec6-2651-4445-865f-ea117dfa88b7" />
<img width="472" height="372" alt="لقطة شاشة 2026-09-11 171232" src="https://github.com/user-attachments/assets/63a6cacf-ffc0-40c4-95c6-4df27a1a9a7a" />
<img width="1485" height="610" alt="لقطة شاشة 2026-09-11 172047" src="https://github.com/user-attachments/assets/a252fe79-2db6-4e98-bfe9-4f4423319c33" />
<img width="1552" height="680" alt="لقطة شاشة 2026-09-11 172131" src="https://github.com/user-attachments/assets/affaf3e4-1c4a-409b-99d2-944eb487d970" />
<img width="1557" height="653" alt="لقطة شاشة 2026-09-11 172209" src="https://github.com/user-attachments/assets/b90584b0-b68e-457c-a21b-97407b78f1e6" />

