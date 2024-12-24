import db from '../utils/db.js';
import moment from 'moment';

const adminService = {
    async getTotalNewsCount() {
        try {
            const result = await db('News').count('Id_News as total');
            return result[0].total
        }
        catch (error) {
            console.error("Lỗi khi đếm số lượng bản ghi:", error);
        }
    },
    async getTotalUserCount() {
        try {
            const result = await db('User').count('Id_User as total');
            //console.log(`Tổng số lượng người dùng: ${result[0].total}`);
            return result[0].total
        }
        catch (error) {
            console.error("Lỗi khi đếm số lượng người dùng:", error);
        }
    },
    async getTotalStaffCount() {
        try {
            const totalAdmin = await db('Administrator').count('Id_User as totalAdmin')
            const totalEditor = await db('Editor').count('Id_User as totalEditor')
            const totalWriter = await db('Writer').count('Id_User as totalWriter')
            const totalStaff = totalAdmin[0].totalAdmin + totalEditor[0].totalEditor + totalWriter[0].totalWriter;
            return totalStaff
        }
        catch (error) {
            console.error("Lỗi khi đếm số lượng người dùng:", error);
        }
    },
    async getTotalAcceptNewsCount() {
        try {
            const result = await db('News')
                .where('Id_Status', 'STS0001')
                .count('Id_News as total');

            //console.log(`Tổng số lượng bản ghi có Id_Status = 'STS0004': ${result[0].total}`);
            return result[0].total
        } catch (error) {
            console.error("Lỗi khi đếm số lượng:", error);
        }
    },
    async getTotalPendingNewsCount() {
        try {
            const result = await db('News')
                .where('Id_Status', 'STS0002')
                .count('Id_News as total');
            return result[0].total
        } catch (error) {
            console.error("Lỗi khi đếm số lượng:", error);
        }
    },
    async getTotalNotAcceptNewsCount() {
        try {
            const result = await db('News')
                .where('Id_Status', 'STS0003')
                .count('Id_News as total');
            return result[0].total
        } catch (error) {
            console.error("Lỗi khi đếm số lượng:", error);
        }
    },
    async getTotalRefuseNewCount() {
        try {
            const result = await db('News')
                .where('Id_Status', 'STS0004')
                .count('Id_News as total');
            return result[0].total
        } catch (error) {
            console.error("Lỗi khi đếm số lượng:", error);
        }
    },
    async getTotalViewsByCategory() {
        try {
            const result = await db('Category')
                .leftJoin('SubCategory', 'Category.Id_Category', 'SubCategory.Id_Category')
                .leftJoin('News', 'SubCategory.Id_SubCategory', 'News.Id_SubCategory')
                .select('Category.Name')
                .sum('News.Views as totalViews')
                .groupBy('Category.Id_Category');

            //console.log("Tổng Views theo Category:", result);
            return result
        } catch (error) {
            console.error("Lỗi khi lấy tổng Views:", error);
        }
    },
    async getViewsByCategoryAndQuater() {

        try {

            return db('Category')
                .leftJoin('SubCategory', 'Category.Id_Category', 'SubCategory.Id_Category')
                .leftJoin('News', 'SubCategory.Id_SubCategory', 'News.Id_SubCategory')
                .select('Category.Name as CategoryName')
                .sum({
                    Q1: db.raw(`CASE WHEN QUARTER(News.Date) = 1 THEN News.Views ELSE 0 END`),
                    Q2: db.raw(`CASE WHEN QUARTER(News.Date) = 2 THEN News.Views ELSE 0 END`),
                    Q3: db.raw(`CASE WHEN QUARTER(News.Date) = 3 THEN News.Views ELSE 0 END`),
                    Q4: db.raw(`CASE WHEN QUARTER(News.Date) = 4 THEN News.Views ELSE 0 END`)
                })
                .where('Category.Status', 1)
                .groupBy('Category.Id_Category', 'Category.Name');
        }
        catch (error) {
            console.error("Lỗi khi lấy tổng Views theo quý:", error);
        }

    },
    async getViewsbyCategory() {
        try {
            const result = await db('Category')
                .leftJoin('SubCategory', 'Category.Id_Category', 'SubCategory.Id_Category')
                .leftJoin('News', 'SubCategory.Id_SubCategory', 'News.Id_SubCategory')
                .select('Category.Name as CategoryName')
                .sum('News.Views as TotalViews')
                .where('Category.Status', 1)
                .groupBy('Category.Id_Category', 'Category.Name');

            return result
        } catch (error) {
            console.error("Lỗi khi lấy tổng Views theo Category:", error);

        }
    },
    async getUserInfor() {
        try {
            const result = await db('User')
                .select(
                    'User.Id_User',
                    'User.Name',
                    'User.Birthday',
                    'User.Email',
                    db.raw(`
      CASE 
        WHEN Editor.Id_Editor IS NOT NULL THEN 'Biên tập viên'
        WHEN Writer.Id_Writer IS NOT NULL THEN 'Nhà báo'
        WHEN Subcriber.Id_Subcriber IS NOT NULL THEN 'Thành viên'
        WHEN Administrator.Id_Administrator IS NOT NULL THEN 'Quản trị viên'
        ELSE 'Chưa cấp quyền'
      END AS Role
    `)
                )
                .leftJoin('Editor', 'User.Id_User', 'Editor.Id_User')
                .leftJoin('Writer', 'User.Id_User', 'Writer.Id_User')
                .leftJoin('Subcriber', 'User.Id_User', 'Subcriber.Id_User')
                .leftJoin('Administrator', 'User.Id_User', 'Administrator.Id_User')
                .whereNot('User.Id_User', 'USR0000');
            return result;
        }
        catch (error) {
            console.error("Lỗi khi lấy tổng Infor User:", error);
        }
    },

    async getCategoryNameById(id_category) {
        try {
            const category = await db('Category').where('Id_Category', id_category).first();
            return category ? category.Name : null; // Trả về tên chuyên mục hoặc null nếu không tìm thấy
        } catch (error) {
            console.error("Lỗi khi lấy tên chuyên mục:", error);
            throw error;
        }
    },
    async getUserInforById(id_user) {
        try {
            const user = await db('User').where('Id_User', id_user).first();
            const writer = await db('Writer').where('Id_User', id_user).first();
            const editor = await db('Editor').where('Id_User', id_user).first();
            const subcriber = await db('Subcriber').where('Id_User', id_user).first();
            const administrator = await db('Administrator').where('Id_User', id_user).first();

            const categoryNameWriter = writer && writer.Id_Category ? await this.getCategoryNameById(writer.Id_Category) : null;
            const categoryNameEditor = editor && editor.Id_Category ? await this.getCategoryNameById(editor.Id_Category) : null;
            return {
                ...user,
                Id_Writer: writer ? writer.Id_Writer : null,
                Id_Editor: editor ? editor.Id_Editor : null,
                Id_Subcriber: subcriber ? subcriber.Id_Subcriber : null,
                Id_Administrator: administrator ? administrator.Id_Administrator : null,
                Pen_Name: writer ? writer.Pen_Name : null,

                Name_Category_Writer: categoryNameWriter,
                Name_Category_Editor: categoryNameEditor,
            };
        } catch (error) {
            console.error('Error fetching user information by ID:', error);
            throw error;
        }
    },
    // async addUsertoSubcriber(entity) {
    //     try {
    //         const lastSubcriber = await db('Subcriber')
    //             .orderBy('Id_Subcriber', 'desc')
    //             .first();

    //         // Tạo ID mới
    //         let newId;
    //         if (!lastSubcriber) {
    //             // Nếu chưa có user nào
    //             newId = 'SUBC0001';
    //         } else {
    //             // Lấy số từ ID cuối cùng và tăng lên 1
    //             const lastNumber = parseInt(lastSubcriber.Id_Subcriber.slice(4));
    //             newId = `SUBC${String(lastNumber + 1).padStart(4, '0')}`;
    //         }

    //         // Gán ID mới vào entity

    //         // Thêm user mới vào database
    //         const ids = await db('Subcriber').insert(entity);
    //         return ids[0];
    //     } catch (error) {
    //         console.error(' error:', error);
    //         throw error;
    //     }
    // },
    async getNewsCountByWriterId(id_writer) {
        try {
            // Truy vấn số lượng bài viết của Writer dựa trên Id_Writer
            // Truy vấn số lượng bài viết của Writer dựa trên Id_Writer và Status = "STS0004"
            const result = await db('News')
                .where('Id_Writer', id_writer)
                .andWhere('Id_Status', 'STS0004') // Thêm điều kiện Status
                .count('Id_News as total');

            if (result.length > 0) {
                return result[0].total; // Trả về số lượng bài viết
            } else {
                return 0; // Nếu không có kết quả, trả về 0
            }

        } catch (error) {
            console.error("Lỗi khi đếm số lượng bài viết của Writer:", error);
            return 0; // Trả về 0 nếu có lỗi
        }
    },
    async getNewsCountByWriterIdAndStatus(id_writer, status) {
        try {
            const result = await db('News')
                .where('Id_Writer', id_writer)
                .andWhere('Id_Status', status)
                .count('Id_News as total');

            if (result.length > 0) {
                return result[0].total; // Trả về số lượng bài viết
            } else {
                return 0; // Nếu không có kết quả, trả về 0
            }
        } catch (error) {
            console.error(`Lỗi khi đếm số lượng bài viết của Writer với status ${status}:`, error);
            return 0; // Trả về 0 nếu có lỗi
        }
    },
    async findWriter(id_user) {
        try {
            const writer = await db('Writer').where('Id_User', id_user).first();
            return writer ? writer.Id_Writer : null; // Trả về Id_Writer nếu tìm thấy
        } catch (error) {
            console.error("Không tìm thấy writer:", error);
            return null; // Trả về null nếu có lỗi
        }
    },
    async updateUserInfo(id_user, name, birthday, pen_name) {
        try {
            // Cập nhật thông tin người dùng
            await db('User')
                .where('Id_User', id_user)
                .update({
                    Name: name,
                    Birthday: birthday
                });

            // Nếu là Writer, cập nhật Pen_Name
            if (pen_name) {
                await db('Writer')
                    .where('Id_User', id_user)
                    .update({
                        Pen_Name: pen_name
                    });
            }
        } catch (error) {
            console.error("Lỗi khi cập nhật thông tin người dùng:", error);
            throw error; // Ném lỗi để xử lý ở route
        }
    },

    async addUsertoSubcriber(id_user) {
        try {
            const lastSubcriber = await db('Subcriber')
                .orderBy('Id_Subcriber', 'desc')
                .first();

            // Tạo ID mới
            let newId;
            if (!lastSubcriber) {
                newId = 'SUBC0001';
            } else {
                const lastNumber = parseInt(lastSubcriber.Id_Subcriber.slice(4));
                newId = `SUBC${String(lastNumber + 1).padStart(4, '0')}`;
            }

            // Gán ngày hiện tại và ngày hết hạn
            const currentDate = moment();
            const dateExpired = moment().add(7, 'days');

            // Thêm user mới vào database
            const entity = {
                Id_Subcriber: newId,
                Id_User: id_user,
                Date_register: currentDate.toDate(),
                Date_expired: dateExpired.toDate(),
            };

            const ids = await db('Subcriber').insert(entity);
            return newId; // Trả về ID của Subscriber mới
        } catch (error) {
            console.error('Lỗi khi thêm Subscriber:', error);
            throw error;
        }
    },
    async getSubscriberInfoByUserId(id_user) {
        try {
            const subscriber = await db('Subcriber').where('Id_User', id_user).first();
            return subscriber; // Trả về thông tin của Subscriber
        } catch (error) {
            console.error("Lỗi khi lấy thông tin Subscriber:", error);
            throw error;
        }
    },
    async updateSubscriberExpirationDate(id_subcriber, newExpirationDate) {
        try {
            await db('Subcriber')
                .where('Id_Subcriber', id_subcriber)
                .update({
                    Date_expired: newExpirationDate
                });
        } catch (error) {
            console.error("Lỗi khi cập nhật ngày hết hạn Subscriber:", error);
            throw error; // Ném lỗi để xử lý ở route
        }
    },
    async deleteSubscriber(id_subcriber) {
        try {
            await db('Subcriber')
                .where('Id_Subcriber', id_subcriber)
                .del(); // Xóa Subscriber
        } catch (error) {
            console.error("Lỗi khi xóa Subscriber:", error);
            throw error; // Ném lỗi để xử lý ở route
        }
    },
    async deleteWriter(id_user) {
        try {
            await db('Writer')
                .where('Id_User', id_user)
                .del(); // Xóa writer
        } catch (error) {
            console.error("Lỗi khi xóa writer:", error);
            throw error; // Ném lỗi để xử lý ở route
        }
    },
    async deleteEditor(id_user) {
        try {
            await db('Editor')
                .where('Id_User', id_user)
                .del(); // Xóa editor
        } catch (error) {
            console.error("Lỗi khi xóa editor:", error);
            throw error; // Ném lỗi để xử lý ở route
        }
    },





    async getCategoryIdByEditorId(editorId) {
        try {
            const editor = await db('Editor')
                .select('Id_Category')
                .where('Id_Editor', editorId) // Giả sử Id_User là khóa chính của Editor
                .first(); // Lấy một bản ghi đầu tiên

            return editor ? editor.Id_Category : null; // Trả về Id_Category hoặc null nếu không tìm thấy
        } catch (error) {
            console.error("Lỗi khi lấy Id_Category của Editor:", error);
            throw error;
        }
    },
    async getNewsCountsForEditor(categoryId) {
        try {
            // Lấy danh sách SubCategory mà Editor quản lý
            const subCategories = await db('SubCategory')
                .where('Id_Category', categoryId); // Giả sử editorId là Id_Category

            const subCategoryIds = subCategories.map(subCat => subCat.Id_SubCategory);

            // Lấy số lượng bài viết theo trạng thái
            const approvedCount = await db('News')
                .whereIn('Id_SubCategory', subCategoryIds)
                .andWhere('Id_Status', 'STS0001') // Đã duyệt
                .count('Id_News as count');

            const pendingCount = await db('News')
                .whereIn('Id_SubCategory', subCategoryIds)
                .andWhere('Id_Status', 'STS0002') // Chưa duyệt
                .count('Id_News as count');

            const notAcceptedCount = await db('News')
                .whereIn('Id_SubCategory', subCategoryIds)
                .andWhere('Id_Status', 'STS0003') // Chưa đạt
                .count('Id_News as count');

            const rejectedCount = await db('News')
                .whereIn('Id_SubCategory', subCategoryIds)
                .andWhere('Id_Status', 'STS0004') // Đã xóa
                .count('Id_News as count');

            return {
                approvedCount: approvedCount[0].count,
                pendingCount: pendingCount[0].count,
                notAcceptedCount: notAcceptedCount[0].count,
                rejectedCount: rejectedCount[0].count
            };
        } catch (error) {
            console.error("Lỗi khi lấy số lượng bài viết:", error);
            throw error;
        }
    },
    async getNewsDetails() {
        try {
            const newsDetails = await db('News')
                .join('Writer', 'News.Id_Writer', 'Writer.Id_Writer')
                .join('SubCategory', 'News.Id_SubCategory', 'SubCategory.Id_SubCategory')
                .join('Category', 'SubCategory.Id_Category', 'Category.Id_Category')
                .leftJoin('News_Tag', 'News.Id_News', 'News_Tag.Id_News')
                .leftJoin('Tag', 'News_Tag.Id_Tag', 'Tag.Id_Tag')
                .select(
                    'News.Id_News',
                    'News.Date',
                    'Writer.Pen_Name',
                    'Category.Name as CategoryName',
                    'SubCategory.Name as SubCategoryName',
                    'News.Title',
                    'News.Views',
                    'News.Id_Status',
                    db.raw('GROUP_CONCAT(Tag.Name) as Tags')
                )
                .groupBy('News.Id_News');

            return newsDetails;
        } catch (error) {
            console.error("Lỗi khi lấy thông tin bài viết:", error);
            throw error;
        }
    },
    async updateNewsStatus(id_news, status) {
        try {
            await db('News')
                .where('Id_News', id_news)
                .update({ Id_Status: status }); // Cập nhật trạng thái
        } catch (error) {
            console.error("Lỗi khi cập nhật trạng thái bài viết:", error);
            throw error;
        }
    },
    async updateSubscriberRequest(id_user, requestValue) {
        try {
            await db('Subcriber')
                .where('Id_User', id_user)
                .update({ Request: requestValue }); // Cập nhật Request
        } catch (error) {
            console.error("Lỗi khi cập nhật thuộc tính Request của Subscriber:", error);
            throw error; // Ném lỗi để xử lý ở route
        }
    },


    // 24/12/2024
    async getCategories() {
        try {
            const categories = await db('Category').where('Status', 1).select('Id_Category', 'Name');
            return categories;
        } catch (error) {
            console.error("Lỗi khi lấy danh sách category:", error);
            throw error;
        }
    },
    async createEditor(id_user, id_category) {
        try {
            // Lấy ID lớn nhất hiện có trong bảng Editor
            const lastEditor = await db('Editor')
                .orderBy('Id_Editor', 'desc')
                .first();

            // Tạo ID mới cho editor
            let newId;
            if (!lastEditor) {
                // Nếu chưa có editor nào
                newId = 'EDT0001';
            } else {
                // Lấy số từ ID cuối cùng và tăng lên 1
                const lastNumber = parseInt(lastEditor.Id_Editor.slice(3));
                newId = `EDT${String(lastNumber + 1).padStart(4, '0')}`;
            }

            // Tạo đối tượng editor mới
            const newEditor = {
                Id_Editor: newId,
                Id_User: id_user,
                Id_Category: id_category
            };

            // Thêm vào bảng Editor
            await db('Editor').insert(newEditor);

            // Cập nhật ngày đăng ký cho tài khoản user
            await db('User')
                .where('Id_User', id_user)
                .update({ Date_register: moment().format('YYYY-MM-DD HH:mm:ss') }); // Cập nhật ngày hiện tại


            return newEditor; // Trả về thông tin editor mới tạo
        } catch (error) {
            console.error('Lỗi khi tạo biên tập viên:', error);
            throw error; // Ném lỗi để xử lý ở route
        }
    },
    async createWriter(id_user, id_category, penname) {
        try {
            // Lấy ID lớn nhất hiện có trong bảng writer
            const lastWriter = await db('Writer')
                .orderBy('Id_Writer', 'desc')
                .first();

            // Tạo ID mới cho 
            let newId;
            if (!lastWriter) {
                // Nếu chưa có  nào
                newId = 'WRT0001';
            } else {
                // Lấy số từ ID cuối cùng và tăng lên 1
                const lastNumber = parseInt(lastWriter.Id_Writer.slice(3));
                newId = `WRT${String(lastNumber + 1).padStart(4, '0')}`;
            }

            // Tạo đối tượng writer mới
            const newWriter = {
                Id_Writer: newId,
                Id_User: id_user,
                Id_Category: id_category,
                Pen_Name: penname
            };

            // Thêm vào bảng 
            await db('Writer').insert(newWriter);

            // Cập nhật ngày đăng ký cho tài khoản user
            await db('User')
                .where('Id_User', id_user)
                .update({ Date_register: moment().format('YYYY-MM-DD HH:mm:ss') }); // Cập nhật ngày hiện tại


            return newWriter; // Trả về thông tin  mới tạo
        } catch (error) {
            console.error('Lỗi khi tạo nhà báo:', error);
            throw error; // Ném lỗi để xử lý ở route
        }
    },
    async getTags() {
        try {
            const tags = await db('Tag').where('Status', 1).select('Id_Tag', 'Name');
            return tags;
        } catch (error) {
            console.error("Lỗi khi lấy danh sách tag:", error);
            throw error;
        }
    },
    async addTag(tag_name) {
        try {
            // Thêm ký tự '#' vào đầu tên tag
            const formattedTagName = `#${tag_name}`;

            // Lấy ID lớn nhất hiện có trong bảng Tag
            const lastTag = await db('Tag')
                .orderBy('Id_Tag', 'desc')
                .first();

            // Tạo ID mới cho tag
            let newId;
            if (!lastTag) {
                // Nếu chưa có tag nào
                newId = 'TAG0001';
            } else {
                // Lấy số từ ID cuối cùng và tăng lên 1
                const lastNumber = parseInt(lastTag.Id_Tag.slice(4));
                newId = `TAG${String(lastNumber + 1).padStart(4, '0')}`;
            }

            const newTag = {
                Id_Tag: newId, // Thêm Id_Tag vào đối tượng
                Name: formattedTagName, // Sử dụng tên tag đã được định dạng
                Status: 1
            };

            await db('Tag').insert(newTag); // Thêm tag vào bảng Tag
        } catch (error) {
            console.error("Lỗi khi thêm tag:", error);
            throw error; // Ném lỗi để xử lý ở route
        }
    },

    // Thêm hàm xóa tag
    async deleteTag(id_tag) {
        try {
            await db('Tag').where('Id_Tag', id_tag).del(); // Xóa tag theo Id_Tag
        } catch (error) {
            console.error("Lỗi khi xóa tag:", error);
            throw error; // Ném lỗi để xử lý ở route
        }
    },



    async getSubCategoriesByCategoryId(id_category) {
        try {
            const subcategories = await db('SubCategory')
                .where('Id_Category', id_category)
                .select('Id_SubCategory', 'Name');
            return subcategories;
        } catch (error) {
            console.error("Lỗi khi lấy subcategories:", error);
            throw error;
        }
    },

    async addSubCategory(id_category, name) {
        try {
            // Lấy ID lớn nhất hiện có trong bảng SubCategory
            const lastSubCategory = await db('SubCategory')
                .orderBy('Id_SubCategory', 'desc')
                .first();

            // Tạo ID mới cho subcategory
            let newId;
            if (!lastSubCategory) {
                // Nếu chưa có subcategory nào
                newId = 'SUB0001';
            } else {
                // Lấy số từ ID cuối cùng và tăng lên 1
                const lastNumber = parseInt(lastSubCategory.Id_SubCategory.slice(3));
                newId = `SUB${String(lastNumber + 1).padStart(4, '0')}`;
            }

            // Tạo đối tượng subcategory mới
            const newSubCategory = {
                Id_SubCategory: newId,
                Id_Category: id_category, // Sử dụng id_category đã chọn
                Name: name
            };

            // Thêm vào bảng SubCategory
            await db('SubCategory').insert(newSubCategory);
            return newSubCategory; // Trả về thông tin subcategory mới tạo
        } catch (error) {
            console.error('Lỗi khi thêm subcategory:', error);
            throw error; // Ném lỗi để xử lý ở route
        }
    },

    async getUserInforById(id_user) {

        try {
            const result = await db('User')
                .select(
                    'User.Id_User',
                    'User.Name',
                    'User.Birthday',
                    'User.Email',
                    db.raw(`
      CASE 
        WHEN Editor.Id_Editor IS NOT NULL THEN 'Editor'
        WHEN Writer.Id_Writer IS NOT NULL THEN 'Writer'
        WHEN Subcriber.Id_Subcriber IS NOT NULL THEN 'Subscriber'
        ELSE 'User'
      END AS Role
    `),
                    db.raw(`
        CASE 
          WHEN Writer.Id_Writer IS NOT NULL THEN Writer.Pen_Name
          ELSE NULL
        END AS Pen_Name
      `)
                )
                .leftJoin('Editor', 'User.Id_User', 'Editor.Id_User')
                .leftJoin('Writer', 'User.Id_User', 'Writer.Id_User')
                .leftJoin('Subcriber', 'User.Id_User', 'Subcriber.Id_User')
                .where('User.Id_User', id_user) // Thêm điều kiện để lấy thông tin cho một người dùng cụ thể
                .first(); // Sử dụng `.first()` để lấy kết quả đầu tiên (một bản ghi duy nhất)


            return result;
        } catch (err) {
            console.error(err);
        }

    },
    async addUsertoSubcriber(entity) {
        try {
            const lastSubcriber = await db('Subcriber')
                .orderBy('Id_Subcriber', 'desc')
                .first();

            // Tạo ID mới
            let newId;
            if (!lastSubcriber) {
                // Nếu chưa có user nào
                newId = 'SUBC0001';
            } else {
                // Lấy số từ ID cuối cùng và tăng lên 1
                const lastNumber = parseInt(lastSubcriber.Id_Subcriber.slice(4));
                newId = `SUBC${String(lastNumber + 1).padStart(4, '0')}`;
            }

            // Gán ID mới vào entity

            // Thêm user mới vào database
            const ids = await db('Subcriber').insert(entity);
            return ids[0];
        } catch (error) {
            console.error(' error:', error);
            throw error;
        }
    }
}
export default adminService