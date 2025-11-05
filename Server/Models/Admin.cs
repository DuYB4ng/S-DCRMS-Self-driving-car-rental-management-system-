using SDCRMS.Models.Enums;

namespace SDCRMS.Models
{
    public class Admin : Users
    {
        public Admin()
        {
            Role = UserRole.Admin; // Tự động set role là Admin
        }

        // Admin-specific methods
        public void GiamSatHeThongVaPhanQuyen()
        {
            // Logic giám sát hệ thống và phân quyền
        }

        public void TheoDoiGiaoDichTaiChinhVaTuanThu()
        {
            // Logic theo dõi giao dịch tài chính và tuần thu
        }

        public void BaoCaoThongKe()
        {
            // Logic báo cáo thống kê
        }

        public void YeuCauPhiChucNang()
        {
            // Logic yêu cầu phí chức năng
        }

        public void DatXe()
        {
            // Logic đặt xe cho admin
        }
    }
}
