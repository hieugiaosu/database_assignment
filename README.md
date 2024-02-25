# Assignment 2 Report - Cyber Gaming Management System

## Database Fundamentals (CO2013)
### Class TN01 - Group 666

### Instructor:
Dr. Nguyen Thi Ai Thao

### Student Contributors:
- Pham The Hieu - 2111213 - Database design, design user service, architecture design
- Do Tin Nghia - 2111837 - Receptionist service
- Huynh Thai Hoc - 2113443 - admin service
- Ta Dinh Tien - 2110583 - Report writer
## System Requirement:

Xây dựng hệ thống quản lý phòng net giúp quản lý net một cách dễ dàng, thân thiện.

Một chủ cửa hàng phòng net cần quản lý phòng net của mình. Một phòng net bao gồm 200 máy tính. Mỗi máy tính cần được lưu thông tin về, mã máy tính (mỗi máy tính có một mã máy tính riêng), thuộc cấu hình nào (bao gồm mã cấu hình, loại CPU, loại card đồ họa, ram, kích thước màn hình, tần số quét màn hình, giá, thông tin RAM), ngày mua máy tính, hãng máy tính. 

Phòng net này phân làm  3 cấp độ máy và giá riêng biệt. Cấp độ máy bình dân, mức giá 6 nghìn đồng cho 1 giờ chơi với cấu hình máy  là loại cpu core i3, ram 16gb, màn hình tần số quét 120 Hz với kích thước màn hình 24 inch. Cấp độ máy trung cấp với  mức giá 15 nghìn đồng cho 1 giờ chơi với cấu hình máy là cpu core i5, ram 16gb, màn hình tần số quét 144 Hz với kích thước màn hình 27 inch. Cấp độ cao cấp với mức giá 30 nghìn đồng cho 1 giờ chơi với cấu hình máy core i7, 32 gb ram, tần số màn hình 240 Hz, mà hình cong kích thước 33 inch.

Phòng net được thiết kế với 3 khu vực riêng biệt bao gồm, khu vực hút thuốc, bao gồm các máy bình dân và trung cấp. Khu vực máy lạnh, có đầy đủ 3 loại máy và khu vực sự kiện, chỉ gồm các máy mức độ cao cấp. Mỗi khu vực khác nhau sẽ có mức phụ thu thêm khác nhau.

Vì phòng net có quy mô lớn, phòng net cần quản lý nhân viên. Mỗi nhân viên bao gồm một mã số nhân viên riêng biệt, ngày tháng năm sinh, họ và tên, giới tính, hợp đồng lao đồng (gồm ngày kí kết hợp đồng lao động, ngày hết hạn hợp đồng lao động). Nhân viên bao gồm nhân viên kĩ thuật, nhân viên lê tân và nhân viên tạp vụ. Đối với nhân viên kỹ thuật, cần lưu trữ chuyên môn của nhân viên đó (mạng, thiết bị, ứng dụng, điện) và cách thức hoạt động (trực tiếp tại quán hoặc từ xa). Mỗi nhân viên kỹ thuật có thể có nhiều chuyên môn. Đối với nhân viên lễ tân, cần lưu trữ lịch trực lễ tân, ngoài ra mỗi lễ tân còn được cấp tài khoản (gồm tài khoản và mật khẩu) để thực hiện các thao tác quản lý. Đối với nhân viên tạp vụ gồm các công việc là bảo vệ, đầu bếp và lao công.

Quán chỉ phục vụ cho hội viên (khách vãng lai muốn được sử dụng dịch vụ phải tạo tài khoản hội viên). Hội viên lưu trữ gồm tài khoản hội viên, mật khẩu hội viên, tên hội viên, số điện thoại hội viên, email hội viên, level(khách thường hoặc khách VIP) và số dư tài khoản hội viên. Mỗi tài khoản hội viên là khác nhau và số điện thoại ứng với mỗi tài khoản hội viên khác nhau là khác nhau. Hội viên sẽ nạp tiền vào tài khoản hội viên. Khi sử dụng dịch vụ tại máy, hội viên sẽ đăng nhập tài khoản hội viên để sử dụng, vì vậy cần có cơ chế lưu trữ thông tin máy nào đang được hội viên nào sử dụng(Session gồm giờ bắt đầu, mã session, giờ kết thúc).

Ngoài phục vụ dịch vụ internet, phòng net còn phục vụ dịch vụ đồ ăn thức uống. Các loại đồ ăn thức uống cần lưu trữ, mã số sản phẩm (mỗi sản phẩm có 1 mã số riêng biệt), tên sản phẩm và giá niêm yết. Các sản phẩm này có thể mua thông qua tài khoản hội viên (không trừ tiền trực tiếp trong tài khoản, trả tiền sau khi nhận sản phẩm) hoặc đặt mua ở quầy lễ tân(có thể trả tiền tại quầy lễ tân). Lễ tân sẽ in hóa đơn cho dịch vụ này và gửi hóa đơn cho hội viên.

Để có tiền trong tài khoản hội viên, hội viện thực hiện nạp tiền vào tài khoản, hội viên thực hiện tại quầy lễ tân, và sẽ được xuất hóa đơn cho lần nạp đó.

Phòng net sẽ có các đợt khuyến mãi khác nhau nhằm tăng doanh thu. Chương trình khuyến mãi được chia làm hai loại: khuyến mãi theo sản phẩm nhất định và khuyến mãi trên tổng hóa đơn. Thông tin chung của chương trình khuyến mãi gồm: mã chương trình (duy nhất), tên chương trình, mô tả, điều kiện áp dụng, ngày bắt đầu, ngày kết thúc, loại. Mỗi đợt khuyến mãi theo sản phẩm sẽ có loại và số lượng sản phẩm khác nhau được áp dụng theo từng đợt. Với chương trình khuyến mãi trên tổng hóa đơn, điều kiện sẽ là mực tối thiểu của hóa đơn. Có thể có nhiều chương trình khuyến mãi với nhau cùng thỏa điều kiện, chỉ áp dụng khuyến mãi có mức giảm cao nhất.

Ngoài ra, phòng net còn yêu cầu quản lý doanh thu theo từng ngày. Cần lưu trữ nhân viên trực, thu nhập từ hội viên nạp tiền, thu nhập từ dịch vụ đồ ăn thức uống. Thống kê giờ chơi theo từng ngày lưu trữ, tổng số giờ chơi ở từng khu vực theo từng loại cấp độ máy.

Cửa hàng sẽ cần lưu trữ lại tất cả các khoản thu chi đã thực hiện. Các thông tin bao gồm ID của khoản (duy nhất), tên khoản, loại khoản (thu hay chi), ngày giờ thực hiện, số tiền. Các hoá đơn được coi là một khoản thu mới và được tự động ghi lại. Ngoài ra, chỉ có nhân viên lễ tân được phép tạo các khoản thu chi mới. Đối với các khoản chi liên quan đến nhập sản phẩm, mỗi loại sản phẩm chỉ có thể nhập từ một nhà cung cấp duy nhất, mỗi nhà cung cấp sản phẩm có một mã số riêng biệt, tên, địa chỉ và số điện thoại. Mỗi lần có bảo trì máy móc, sẽ cần ghi một biên bản cần ghi chi phí sửa chữa, tình trạng trước bảo trì, tình trạng sau bảo trì, ngày thực hiện , mã biên bản. Chi phí này sẽ được xuất hóa đơn chi.

## Database design

- EERD hệ thống

![Alt text](database/eerd.png?raw=true "EERD hệ thông")

- schema hệ thống

![Alt text](database/schema.png?raw=true "schema hệ thông")

## system architecture

- Service base architecture 

![Alt text](database/architecture.png?raw=true "service base")